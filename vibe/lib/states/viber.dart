import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'container.dart';
import 'equals.dart';

abstract interface class GeneratedViber<T> {
  T Function(VibeContainer container, {bool override}) toVibe();
  dynamic get $key;
  dynamic get $effectKey;
  dynamic get $loaderKey;
}

mixin Viber<T> on EquatableMixin {
  final subject = BehaviorSubject<List>();
  final Set<Viber> _dependencies = {};
  late final stream = subject.where((_) => _refCount != 0).distinct((a, b) {
    final result = deepEquals(a, b);
    return result;
  }).map<T>((event) => this as T);

  final List<StreamSubscription> subscriptions = [];

  bool get autoDispose;
  VibeContainer get container;
  dynamic get $key;

  int _refCount = 0;

  @nonVirtual
  void ref() {
    ++_refCount;
  }

  @nonVirtual
  void unref() {
    assert(_refCount > 0, 'Unreferences more than referenced');
    --_refCount;
    if (_refCount == 0 && autoDispose) {
      dispose();
    }
  }

  @nonVirtual
  void notify({bool force = false}) {
    subject.add([
      ...props,
      if (force) DateTime.now() else null,
    ]);
  }

  @nonVirtual
  void addDependency(Viber v) {
    if (_dependencies.contains(v)) {
      return;
    }
    _dependencies.add(v..ref());
  }

  void addSubscription(StreamSubscription sub) {
    subscriptions.add(sub);
  }

  Future<V> loadVibe<V>(GeneratedViber<V> v) async =>
      v.toVibe()(container, override: false);

  @mustCallSuper
  void dispose() {
    for (final d in _dependencies) {
      d.unref();
    }
    _dependencies.clear();
    for (final sub in subscriptions) {
      sub.cancel();
    }
    subscriptions.clear();
    container.remove($key);
    subject.close();
  }
}
