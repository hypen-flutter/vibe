import 'dart:async';

import 'package:collection/collection.dart';
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
      expect(counter.stream, isA<Stream>());
    });

    test('can have a initial value', () {
      final cb = expectAsync1((c) => expect(c, isA<Counter>()));
      counter.stream.listen(cb);
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

    test('does not notify when change the NotVibe', () {
      final cb = expectAsync1((_) {}, count: 1);
      counter.stream.listen(cb);
      counter.nothing++;
      expect(counter.nothing, equals(1));
    });
    test('does not notify on increaseNothing()', () {
      final cb = expectAsync1((_) {}, count: 1);
      counter.stream.listen(cb);
      counter.increaseNothing();
      expect(counter.nothing, equals(1));
    });
  });
  return 0;
}

@Vibe()
class Counter {
  int count = 0;

  @NotVibe()
  int nothing = 0;
  void increase() => ++count;
  void decrease() => --count;
  void increaseNothing() => ++nothing;
}

class $Counter implements Counter {
  $Counter() {
    notify();
  }
  final subject = BehaviorSubject<List>();
  final equality = const DeepCollectionEquality();
  late final stream =
      subject.distinct(equality.equals).map((event) => event[0]);

  Counter src = Counter();

  @override
  int get count => src.count;

  @override
  set count(val) {
    src.count = val;
    notify();
  }

  @override
  int get nothing => src.nothing;

  @override
  set nothing(val) {
    src.nothing = val;
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

  @override
  void increaseNothing() {
    src.increaseNothing();
    notify();
  }

  void notify() {
    subject.add([this, count]);
  }
}
