import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../states/states.dart';

/// Vibe version of [StatelessWidget]
abstract class VibeStatelessWidget extends VibeStatefulWidget {
  const VibeStatelessWidget({super.key});

  Widget loader(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }

  Widget build(BuildContext context);

  @nonVirtual
  @override
  VibeWidgetState<VibeStatefulWidget> createState() =>
      _VibeStatelessWidgetState();
}

class _VibeStatelessWidgetState extends VibeWidgetState<VibeStatelessWidget> {
  @override
  Widget loader(BuildContext context) {
    VibeStatefulElement.setState(widget, this);
    return widget.loader(context);
  }

  @override
  Widget build(BuildContext context) {
    VibeStatefulElement.setState(widget, this);
    return widget.build(context);
  }

  @override
  void dispose() {
    VibeStatefulElement.removeState(widget);
    super.dispose();
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
  final List<StreamSubscription> _vibes = [];

  /// Build loader for async states
  Widget loader(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }

  @override
  Widget build(BuildContext context);

  @override
  void dispose() {
    for (final v in _vibes) {
      v.cancel();
    }
    _vibes.clear();
    super.dispose();
  }

  /// Add the vibe [StreamSubscription]
  @nonVirtual
  void addVibe(StreamSubscription sub) {
    _vibes.add(sub);
  }

  /// [setState] delegate
  @nonVirtual
  void markNeedsBuild() {
    setState(() {});
  }
}

/// Delegate of the [VibeStatefulWidget]
class VibeStatefulElement extends StatefulElement {
  VibeStatefulElement(super.widget);
  static final Map<Widget, VibeWidgetState> _statelessState = {};

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
  static VibeContainer getContainer(Widget widget) {
    final context = getContext(widget);
    assert(
      context != null,
      'You can not call [getContainer] with non-[VibeStatelessWidget]',
    );
    return _InheritedVibeContainer.of(context!);
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
    return _InheritedVibeContainer(
      container: container,
      child: widget.child,
    );
  }
}

class _InheritedVibeContainer extends InheritedWidget {
  const _InheritedVibeContainer({
    required this.container,
    required super.child,
  });

  final VibeContainer container;
  static final VibeContainer _container = VibeContainer();

  static VibeContainer of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_InheritedVibeContainer>()
            ?.container ??
        _InheritedVibeContainer._container;
  }

  @override
  bool updateShouldNotify(covariant _InheritedVibeContainer oldWidget) {
    return container != oldWidget.container;
  }
}
