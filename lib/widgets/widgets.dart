import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../states/states.dart';

/// Vibe version of [StatelessWidget]
abstract class VibeStatelessWidget extends VibeStatefulWidget {
  const VibeStatelessWidget({super.key});

  /// Build loading [Widget] while async [Vibe] is loading
  Widget loader(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }

  /// Same as the [StatelessWidget.build]
  Widget build(BuildContext context);

  List<Viber Function()> get initializers => [];

  @nonVirtual
  @override
  VibeWidgetState<VibeStatefulWidget> createState() =>
      _VibeStatelessWidgetState();
}

class _VibeStatelessWidgetState extends VibeWidgetState<VibeStatelessWidget> {
  @override
  List<Viber Function()> get initializers => widget.initializers;

  @override
  Widget loader(BuildContext context) {
    return widget.loader(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
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
  final List<StreamSubscription> _subscriptions = [];
  final List<Viber> _vibers = [];
  final List<void Function()> _onDisposes = [];
  List<Viber Function()> get initializers => [];

  @override
  void initState() {
    super.initState();
    VibeStatefulElement.setState(widget, this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final container = InheritedVibeContainer.of(context);
    if (container != VibeStatefulElement.getContainer(widget)) {
      VibeStatefulElement.setContainer(widget, container);
      for (final init in initializers) {
        init();
      }
    }
  }

  /// Build loader for async states
  Widget loader(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }

  @override
  Widget build(BuildContext context);

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    for (final v in _vibers) {
      v.unref();
    }
    _vibers.clear();

    for (final f in _onDisposes) {
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
  static final Map<Widget, VibeWidgetState> _statelessState = {};
  static final Map<Widget, VibeContainer> _container = {};

  /// Sets the [BuildContext]
  static setState(Widget widget, VibeWidgetState state) =>
      _statelessState[widget] = state;

  /// Removes the [BuildContext]
  static removeState(Widget widget) => _statelessState.remove(widget);

  /// Gets the [BuildContext]
  static BuildContext? getContext(Widget widget) =>
      _statelessState[widget]?.context;

  /// Gets the [VibeWidgetState]
  static VibeWidgetState? getState(Widget widget) => _statelessState[widget];

  /// Gets the inherited [VibeContainer]
  static VibeContainer? getContainer(Widget widget) {
    return _container[widget];
  }

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
  Widget build() {
    return state.ready ? super.build() : (state).loader(this);
  }
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
  final container = VibeContainer();
  @override
  Widget build(BuildContext context) {
    return InheritedVibeContainer(
      container: container,
      child: widget.child,
    );
  }
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

  static VibeContainer of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<InheritedVibeContainer>()
            ?.container ??
        InheritedVibeContainer.globalContainer;
  }

  @override
  bool updateShouldNotify(covariant InheritedVibeContainer oldWidget) {
    return container != oldWidget.container;
  }
}
