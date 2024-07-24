import 'package:vibe/vibe.dart';

import 'counter_example.dart';

@VibeEffect()
class MyEffect with $MyEffect, $CounterEffect {
  @LinkVibe()
  late final Counter counter;
}

mixin $MyEffect implements GeneratedVibeEffect {
  @override
  MyEffect toVibeEffect(VibeContainer container) => _MyEffect(container);
}

class _MyEffect extends MyEffect {
  _MyEffect(this.container);
  final VibeContainer container;
  @override
  Counter get counter => $Counter.find(container);
}

mixin $CounterEffect {
  Future<void> onCounterSetCount() async {}
  Future<void> onCounterIncrease() async {}
  Future<void> onCounterDecrease() async {}
  Future<void> onCounterIncreaseNothing() async {}
}
