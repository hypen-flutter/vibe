import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

import 'counter_example.dart';

@VibeEffect(<dynamic>[Counter])
class MyEffect with $CounterEffect {}

mixin $CounterEffect {
  late VibeContainer container;
  Counter get counter => $Counter.find(container);
  Future<void> onCounterSetCount() async {}
  Future<void> onCounterIncrease() async {}
  Future<void> onCounterDecrease() async {}
}
