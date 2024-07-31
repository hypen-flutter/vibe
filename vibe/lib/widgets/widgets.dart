import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../annotations/state_annotations.dart';
import '../states/container.dart';
import '../states/effect.dart';
import '../states/viber.dart';

/// Vibe version of [StatelessWidget]
abstract class VibeWidget extends VibeStatefulWidget {
  const VibeWidget({super.key});

  /// Build loading [Widget] while async [Vibe] is loading
  Widget loader(BuildContext context) =>
      const CircularProgressIndicator.adaptive();

  /// Same as the [StatelessWidget.build]
  Widget build(BuildContext context);

  /// Fields expected as [Vibe]s
  List<dynamic> get vibes => [];

  @nonVirtual
  @override
  VibeWidgetState<VibeStatefulWidget> createState() =>
      _VibeStatelessWidgetState();
  VibeContainer get $container => VibeStatefulElement.getContainer(this)!;
  VibeWidgetState get $state => VibeStatefulElement.getState(this)!;
}

/// Scoping the [Computed] Vibe to be built inside of this widget.
class VibeSuspense extends VibeWidget {
  const VibeSuspense({
    required this.builder,
    super.key,
    this.loading,
  });

  /// Be used as a loading indicator
  final Widget Function(BuildContext context)? loading;

  /// Actual part of the UI
  final Widget Function(BuildContext context) builder;

  @override
  Widget loader(BuildContext context) => (loading ?? super.loader)(context);
  @override
  Widget build(BuildContext context) => builder(context);
}

class _VibeStatelessWidgetState extends VibeWidgetState<VibeWidget> {
  @override
  List get vibes => widget.vibes;

  @override
  Widget loader(BuildContext context) => widget.loader(context);

  @override
  Widget build(BuildContext context) => widget.build(context);
}

/// Vibe version of [StatefulWidget].
///
/// [VibeStatefulWidget.createState] must return [VibeWidgetState].
abstract class VibeStatefulWidget extends StatefulWidget {
  const VibeStatefulWidget({super.key});

  @nonVirtual
  @override
  StatefulElement createElement() => VibeStatefulElement(this);

  @override
  VibeWidgetState createState();
}

/// [State] for [VibeStatefulWidget]
abstract class VibeWidgetState<T extends VibeStatefulWidget> extends State<T> {
  final List<StreamSubscription> _subscriptions = <StreamSubscription>[];
  final Set<Viber> _registeredVibes = <Viber>{};

  /// Fields expected as [Vibe]s
  List<dynamic> get vibes => [];
  late final Set<Viber> _manualVibes = vibes.whereType<Viber>().toSet();

  /// DO NOT USE THIS
  VibeContainer get $container => VibeStatefulElement.getContainer(widget)!;

  /// DO NOT USE THIS
  VibeWidgetState get $state => VibeStatefulElement.getState(widget)!;
  bool get _manualVibeNotRegistered =>
      _registeredVibes.length != _manualVibes.length;

  @override
  void initState() {
    super.initState();
    VibeStatefulElement.setState(widget, this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final VibeContainer container = InheritedVibeContainer.of(context);
    if (container != VibeStatefulElement.getContainer(widget)) {
      VibeStatefulElement.setContainer(widget, container);
      _clearVibes();
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      VibeStatefulElement.removeState(oldWidget);
      VibeStatefulElement.setState(widget, this);
    }
  }

  /// Build loader for async states
  Widget loader(BuildContext context) =>
      const CircularProgressIndicator.adaptive();

  @override
  Widget build(BuildContext context);

  @override
  void dispose() {
    _clearVibes();

    VibeStatefulElement.removeContainer(widget);
    VibeStatefulElement.removeState(widget);

    super.dispose();
  }

  /// Add the vibe [StreamSubscription]
  ///
  /// Users will never call this.
  @nonVirtual
  void addVibe(Viber v) {
    if (_registeredVibes.contains(v)) {
      if (v.subject.valueOrNull == null) {
        throw const LoadingVibeException();
      }
      return;
    }
    _registeredVibes.add(v..ref());
    // Wait for the other dependencies
    if (v.subject.valueOrNull == null) {
      v.stream.first.then((_) {
        if (mounted) {
          setState(() {
            _addSubscription(v);
          });
        }
      });
      throw const LoadingVibeException();
    } else {
      _addSubscription(v);
    }
  }

  void _addSubscription(Viber v) {
    _subscriptions.add(v.stream.skip(1).listen((_) {
      if (mounted) {
        setState(() {});
      }
    }));
  }

  /// Redirect to `setState`
  @nonVirtual
  void rebuild() {
    setState(() {});
  }

  /// Clears the dependencies
  @nonVirtual
  void _clearVibes() {
    for (final StreamSubscription s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    for (final Viber v in _registeredVibes) {
      v.unref();
    }
    _registeredVibes.clear();
  }

  void _addManualVibes() {
    _manualVibes.forEach(addVibe);
  }
}

/// Delegate of the [VibeStatefulWidget]
class VibeStatefulElement extends StatefulElement {
  VibeStatefulElement(super.widget);
  static final Map<Widget, VibeWidgetState> _statelessState =
      <Widget, VibeWidgetState<VibeStatefulWidget>>{};
  static final Map<Widget, VibeContainer> _container =
      <Widget, VibeContainer>{};

  /// Sets the [BuildContext]
  static VibeWidgetState<VibeStatefulWidget> setState(
          Widget widget, VibeWidgetState state) =>
      _statelessState[widget] = state;

  /// Removes the [BuildContext]
  static VibeWidgetState<VibeStatefulWidget>? removeState(Widget widget) =>
      _statelessState.remove(widget);

  /// Gets the [BuildContext]
  static BuildContext? getContext(Widget widget) =>
      _statelessState[widget]?.context;

  /// Gets the [VibeWidgetState]
  static VibeWidgetState? getState(Widget widget) => _statelessState[widget];

  /// Gets the inherited [VibeContainer]
  static VibeContainer? getContainer(Widget widget) => _container[widget];

  /// Sets the inherited [VibeContainer]
  static void setContainer(Widget widget, VibeContainer container) {
    _container[widget] = container;
  }

  /// Removes the related [VibeContainer]
  static void removeContainer(Widget widget) {
    _container.remove(widget);
  }

  @override
  VibeWidgetState get state => super.state as VibeWidgetState;

  @override
  Widget build() {
    try {
      if (state._manualVibeNotRegistered) {
        state._addManualVibes();
      }
      return super.build();
    } on LoadingVibeException {
      return state.loader(this);
    } on Exception {
      rethrow;
    }
  }
}

/// [VibeContainer] holder
class VibeScope extends VibeStatefulWidget {
  const VibeScope({
    required this.child,
    this.overrides = const [],
    this.effects = const [],
    super.key,
  });

  /// Child widget
  final Widget child;

  /// Side effects that implements [VibeEffect]
  final List<VibeEffect> effects;

  /// Overrides the [Vibe] classes
  final List<Viber Function(VibeContainer container, {bool override})>
      overrides;

  @override
  VibeWidgetState<VibeStatefulWidget> createState() => _VibeScopeState();
}

class _VibeScopeState extends VibeWidgetState<VibeScope> {
  late final VibeContainer container =
      VibeContainer(parent: InheritedVibeContainer.of(context));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentParent = InheritedVibeContainer.of(context);
    if (container.parent != currentParent) {
      container.parent = currentParent;
    }
    for (final override in widget.overrides) {
      override(container, override: true);
    }
    for (final effect in widget.effects) {
      effect
        ..init()
        ..register(container);
    }
  }

  @override
  Widget build(BuildContext context) => InheritedVibeContainer(
        container: container,
        child: widget.child,
      );
}

/// Source of the [VibeContainer]
@visibleForTesting
class InheritedVibeContainer extends InheritedWidget {
  const InheritedVibeContainer({
    required this.container,
    required super.child,
    super.key,
  });

  /// Scoped [VibeContainer]
  final VibeContainer container;

  /// Main [VibeContainer]
  @visibleForTesting
  static final VibeContainer globalContainer = VibeContainer();

  /// Always returns [VibeContainer]
  static VibeContainer of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<InheritedVibeContainer>()
          ?.container ??
      InheritedVibeContainer.globalContainer;

  @override
  bool updateShouldNotify(covariant InheritedVibeContainer oldWidget) =>
      container != oldWidget.container;
}

/// Exception when the widget accesses to the [Computed] vibes.
class LoadingVibeException implements Exception {
  const LoadingVibeException([this.message = 'Loading Vibe']);
  final String message;

  @override
  String toString() => '[LoadingVibeException] $message';
}
