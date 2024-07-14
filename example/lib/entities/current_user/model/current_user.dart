import 'package:example/vibe_wrapper/async.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

part 'hello.dart';

class Vibe {
  const Vibe([this.name]);
  final dynamic name;
}

class NotTrack {
  const NotTrack();
}

class LinkVibe {
  const LinkVibe([this.viber]);
  final dynamic viber;
}

class SelectVibe {
  const SelectVibe([this.vibers = const []]);
  final List<dynamic> vibers;
}

class StreamVibe {
  const StreamVibe([this.vibers = const []]);
  final List<dynamic> vibers;
}

@Vibe()
class Counter with _Counter {
  int count = 0;
  void increase() {
    ++count;
  }

  void decrease() {
    --count;
  }
}

mixin VibeEffect {}

mixin _Counter {}

mixin CounterEffect {}

@Vibe()
class Derived with _DerivedVibe {
  int a = 0;

  @NotTrack()
  int b = 0;

  @LinkVibe()
  late final Counter counter;

  @SelectVibe([Counter])
  late final int count;

  @StreamVibe([Counter])
  late final int debouncedCount;

  @override
  int _selectCount(Counter counter) {
    // TODO: implement _selectCount
    throw UnimplementedError();
  }

  @override
  Stream<int> _streamDebouncedCount(Stream<Counter> counter) {
    // TODO: implement _streamDebouncedCount
    throw UnimplementedError();
  }
}

class VibeContainer {
  final Map<dynamic, BehaviorSubject> _container = {};

  BehaviorSubject<T>? find<T>(dynamic key) {
    return _container[key] as BehaviorSubject<T>?;
  }

  BehaviorSubject<T> insert<T>(dynamic key, BehaviorSubject<T> subject) {
    return _container[key] = subject;
  }

  BehaviorSubject<T>? remove<T>(dynamic key) {
    return _container.remove(key) as BehaviorSubject<T>?;
  }
}

typedef UnregisterVibee = void Function();

mixin Viber {
  final Map<dynamic, Set<Vibee>> vibees = {};
  final Map<Vibee, Set<dynamic>> keys = {};
  BehaviorSubject get subject;

  Vibee? vb;

  UnregisterVibee setVibee(Vibee vb) {
    this.vb = vb;
    return () => unregisterVibee(vb);
  }

  void notifySubject() {
    subject.add(this);
  }

  void notifyField<T>(dynamic key, T val) {
    final vibees = this.vibees[key] ?? {};
    for (final vibee in vibees) {
      Future(() {
        vibee.rebuild();
      });
    }
  }

  void registerField<T>(dynamic key) {
    if (vb == null) {
      return;
    }
    final vibelets = vibees[key] ??= {};
    final keys = this.keys[vb!] ??= {};

    keys.add(key);
    vibelets.add(vb!);
  }

  void unregisterVibee(Vibee vb) {
    final keys = this.keys[vb] ?? {};
    for (final key in keys) {
      vibees[key]?.remove(vb);
    }
    this.keys.remove(vb);
  }

  @mustCallSuper
  void dispose() {
    vibees.clear();
    keys.clear();
  }
}

mixin Vibee {
  void reassignViber<T>() {}

  void rebuild() {}
}
