import 'dart:async';

import 'package:vibe/vibe.dart';

part 'counter_example.vibe.dart';

@Vibe()
class Counter with _Counter {
  Counter();

  @Loader()
  factory Counter.fromRemote(int id) => $CounterFromRemote(id);

  int count = 0;

  @NotVibe()
  int? nothing = 0;

  final unmodifiable = 0;

  void increase() => ++count;
  void decrease() => --count;

  void increaseNothing() => nothing = (nothing ?? 0) + 1;

  void hoho(int a, int b, int c,
      {required int g, int d = 0, int e = 0, int f = 0}) {}

  late void Function() forTest = () {};

  Future<void> asyncFunction() async {}

  @override
  void dispose() {
    forTest();
  }
}

typedef CounterFromRemote = Future<Counter> Function(int id);

class $CounterFromRemote extends Counter with VibeEquatableMixin {
  $CounterFromRemote(this.id);

  final int id;

  @override
  late dynamic $key = this;

  @override
  List<Object?> get props => [$CounterFromRemote, id];
}

mixin LoadCounterFromRemote on VibeEffect {
  @override
  void init() {
    super.init();
    addKey($CounterFromRemote);
  }

  Future<Counter> loadCounterFromRemote(int id);
}
