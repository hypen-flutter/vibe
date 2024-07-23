import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

import 'counter_example.dart';

@VibeEffect([Counter])
class MyEffect with $CounterEffect {}

mixin $CounterEffect {
  late VibeContainer container;
  Counter get counter => $Counter.find(container);
  void onCounterSetCount() async {}
  void onCounterIncrease() async {}
  void onCounterDecrease() async {}
}
