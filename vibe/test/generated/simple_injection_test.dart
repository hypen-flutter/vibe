import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/counter_example.dart';
import 'examples/injection_example.dart';

int main() {
  group('Simple Injection', () {
    late $Derived derived;
    late $Counter counter;
    late VibeContainer container;
    setUp(() async {
      container = VibeContainer();
      counter = $Counter.find(container);
      derived = $Derived.find(container);
      await Future.delayed(const Duration(milliseconds: 500));
    });

    test('can have initial values', () async {
      expect(derived.counter, equals(counter));
      expect(derived.counter.count, equals(0));
      expect(derived.count, equals(0));
      expect(derived.streamedCount, equals(0));
    });
    test('react on linked vibe changes', () async {
      counter.increase();
      await Future.delayed(Duration.zero);
      expect(derived.count, equals(1));
      expect(derived.streamedCount, equals(0));
      counter.increase();
      await Future.delayed(Duration.zero);
      expect(derived.count, equals(2));
      expect(derived.streamedCount, equals(2));
    });

    test('reacts on change fields', () async {
      derived.count++;
      await Future.delayed(Duration.zero);
      expect(derived.count, equals(1));
    });
    test('reacts again on linked vibe after change fields', () async {
      derived.count++;
      derived.count++;
      derived.count++;
      await Future.delayed(Duration.zero);
      expect(derived.count, equals(3));
      counter.increase();
      await Future.delayed(Duration.zero);
      expect(derived.count, equals(1));
    });
  });

  return 0;
}
