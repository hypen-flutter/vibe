import 'dart:async';

import 'package:vibe/vibe.dart';

part 'counter_example.vibe.dart';

@Vibe()
class Counter with _Counter {
  Counter();

  int count = 0;

  @Silent()
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
