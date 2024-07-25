import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../annotations/state_annotations.dart';
import '../states/container.dart';
import '../states/viber.dart';

/// Vibe version of [StatelessWidget]
abstract class VibeWidget extends VibeStatefulWidget {
  const VibeWidget({super.key});

  /// Build loading [Widget] while async [Vibe] is loading
  Widget loader(BuildContext context) =>
      const CircularProgressIndicator.adaptive();

  /// Same as the [StatelessWidget.build]
  Widget build(BuildContext context);

  List<Viber Function()> get initializers => <Viber Function()>[];

  @nonVirtual
  @override
  VibeWidgetState<VibeStatefulWidget> createState() =>
      _VibeStatelessWidgetState();
  VibeContainer get $container => VibeStatefulElement.getContainer(this)!;
  VibeWidgetState get $state => VibeStatefulElement.getState(this)!;
}

class _VibeStatelessWidgetState extends VibeWidgetState<VibeWidget> {
  @override
  List<Viber Function()> get initializers => widget.initializers;

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
  final List<Viber> _vibers = <Viber>[];
  final List<void Function()> _onDisposes = <void Function()>[];
  List<Viber Function()> get initializers => <Viber Function()>[];

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
      for (final Viber Function() init in initializers) {
        init();
      }
    }
  }

  /// Build loader for async states
  Widget loader(BuildContext context) =>
      const CircularProgressIndicator.adaptive();

  @override
  Widget build(BuildContext context);

  @override
  void dispose() {
    for (final StreamSubscription s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    for (final Viber v in _vibers) {
      v.unref();
    }
    _vibers.clear();

    for (final void Function() f in _onDisposes) {
      f();
    }
    _onDisposes.clear();

    VibeStatefulElement.removeContainer(widget);
    VibeStatefulElement.removeState(widget);

    super.dispose();
  }

  int numReady = 0;
  bool get ready => numReady == _vibers.length;

  /// Add the vibe [StreamSubscription]
  ///
  /// Users will never call this.
  @nonVirtual
  void addVibe(Viber v, void Function() onDispose) {
    _vibers.add(v..ref());
    _onDisposes.add(onDispose);
    // Wait for the other dependencies
    v.stream.take(1).listen((_) {
      ++numReady;
      if (mounted) {
        setState(() {});
      }
    });
    _subscriptions.add(v.stream.skip(1).listen((_) {
      if (mounted) {
        setState(() {});
      }
    }));
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

  static void removeContainer(Widget widget) {
    _container.remove(widget);
  }

  @override
  VibeWidgetState get state => super.state as VibeWidgetState;

  @override
  Widget build() => state.ready ? super.build() : state.loader(this);
}

/// [VibeContainer] holder
class VibeScope extends VibeStatefulWidget {
  const VibeScope({required this.child, super.key});

  /// Child widget
  final Widget child;

  @override
  VibeWidgetState<VibeStatefulWidget> createState() => _VibeScopeState();
}

class _VibeScopeState extends VibeWidgetState<VibeScope> {
  final VibeContainer container = VibeContainer();
  @override
  Widget build(BuildContext context) => InheritedVibeContainer(
        container: container,
        child: widget.child,
      );
}

@visibleForTesting
class InheritedVibeContainer extends InheritedWidget {
  const InheritedVibeContainer({
    required this.container,
    required super.child,
    super.key,
  });

  final VibeContainer container;
  @visibleForTesting
  static final VibeContainer globalContainer = VibeContainer();

  static VibeContainer of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<InheritedVibeContainer>()
          ?.container ??
      InheritedVibeContainer.globalContainer;

  @override
  bool updateShouldNotify(covariant InheritedVibeContainer oldWidget) =>
      container != oldWidget.container;
}
