import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/states/states.dart';

import 'examples/counter_example.dart';

int main() {
  group('Simple Vibe', () {
    late $Counter counter;
    late VibeContainer container;
    setUp(() {
      container = VibeContainer();
      counter = $Counter.find(container)..ref();
    });

    test('can generate a stream initialization code ', () {
      expect(counter, isA<Counter>());
      expect(counter.stream, isA<Stream>());
    });

    test('can have a initial value', () {
      final Func1<void, Object?> cb =
          expectAsync1((Object? c) => expect(c, isA<Counter>()));
      counter.stream.listen(cb);
    });

    test('can notify the change on increase()', () {
      final Func1<void, Object?> cb = expectAsync1((_) {}, count: 2);
      counter.stream.listen(cb);
      counter.increase();
      expect(counter.count, equals(1));
    });
    test('can notify the change on decrease()', () {
      final Func1<void, Object?> cb = expectAsync1((_) {}, count: 2);
      counter.stream.listen(cb);
      counter.decrease();
      expect(counter.count, equals(-1));
    });
    test('can notify manual modification', () {
      final Func1<void, Object?> cb = expectAsync1((_) {}, count: 2);
      counter.stream.listen(cb);
      counter.count++;
      expect(counter.count, equals(1));
    });

    test('does not notify when change the NotVibe', () {
      final Func1<void, Object?> cb = expectAsync1((_) {});
      counter.stream.listen(cb);
      counter.nothing++;
      expect(counter.nothing, equals(1));
    });
    test('does not notify on increaseNothing()', () {
      final Func1<void, Object?> cb = expectAsync1((_) {});
      counter.stream.listen(cb);
      counter.increaseNothing();
      expect(counter.nothing, equals(1));
    });

    test('auto dispose the counter when ref goes down to zero', () {
      final Func0<void> cb = expectAsync0(() {});
      counter
        ..forTest = cb
        ..increase()
        ..unref();

      counter = $Counter.find(container);
      expect(counter.count, equals(0));
    });
  });
  return 0;
}
