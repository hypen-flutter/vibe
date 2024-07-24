import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import '../generated/examples/counter_example.dart';

int main() {
  group('VibeContainer', () {
    late VibeContainer container;
    setUp(() {
      container = VibeContainer()
        ..add(Counter, const Stream<Counter>.empty())
        ..add(#Counter, const Stream<Counter>.empty());
    });

    test('can retrieve streams', () async {
      final s1 = container.find(Counter);
      final s2 = container.find(#Counter);
      expect(container.find(#asdf), isNull);
      expect(s1, isA<Stream<Counter>>());
      expect(s2, isA<Stream<Counter>>());
    });

    test('can remove streams', () async {
      container.remove(Counter);
      expect(container.find(Counter), isNull);
      expect(container.find(#Counter), isNotNull);

      container.remove(#Counter);
      expect(container.find(#Counter), isNull);
    });
  });
  return 0;
}
