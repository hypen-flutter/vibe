import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/counter_example.dart';
import 'examples/effect_example.dart';

int main() {
  group('[VibeEffect]', () {
    late VibeContainer container;
    late MyEffect effect;
    setUp(() {
      container = VibeContainer();
      effect = MyEffect().toVibeEffect(container);
    });
    test('can access [Counter]', () {
      final Counter counter = effect.counter;
      expect(counter.count, equals(0));
    });
  });
  return 0;
}
