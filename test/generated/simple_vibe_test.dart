import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';
import 'package:vibe/annotations/annotations.dart';

int main() {
  group('Simple Vibe', () {
    late $Counter counter;
    setUp(() {
      counter = $Counter();
    });
    test('can generate a stream initialization code ', () {
      expect(counter.stream, isA<Stream<Counter>>());
    });

    test('can have a initial value', () {
      final value = counter.subject.value;
      expect(value, isA<Counter>());
    });

    test('can notify the change on increase()', () {
      final cb = expectAsync1((_) {}, count: 2);
      counter.stream.listen(cb);
      counter.increase();
      expect(counter.count, equals(1));
    });
    test('can notify the change on decrease()', () {
      final cb = expectAsync1((_) {}, count: 2);
      counter.stream.listen(cb);
      counter.decrease();
      expect(counter.count, equals(-1));
    });
    test('can notify manual modification', () {
      final cb = expectAsync1((_) {}, count: 2);
      counter.stream.listen(cb);
      counter.count++;
      expect(counter.count, equals(1));
    });
  });
  return 0;
}

@Vibe()
class Counter {
  int count = 0;
  void increase() => ++count;
  void decrease() => --count;
}

class $Counter with EquatableMixin implements Counter {
  late final subject = BehaviorSubject<Counter>()..add(src);
  late final stream = subject.distinct();

  Counter src = Counter();

  @override
  int get count => src.count;

  @override
  set count(val) {
    src.count = val;
    notify();
  }

  @override
  void decrease() {
    src.decrease();
    notify();
  }

  @override
  void increase() {
    src.increase();
    notify();
  }

  void notify() {
    subject.add(this);
  }

  @override
  List<Object?> get props => [count];
}
