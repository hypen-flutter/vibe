import 'package:equatable/equatable.dart';
import 'package:vibe/annotations/state_annotations.dart';
import 'package:vibe/states/states.dart';

@Vibe()
class Counter with _Counter {
  int count = 0;

  @NotVibe()
  int nothing = 0;

  void increase() => ++count;
  void decrease() => --count;

  void increaseNothing() => ++nothing;

  late void Function() forTest = () {};

  @override
  void dispose() {
    forTest();
  }
}

mixin _Counter {
  void dispose() {}
}

class $Counter with EquatableMixin, Viber<$Counter> implements Counter {
  $Counter(this.container);

  factory $Counter.find(VibeContainer container) =>
      container.find<$Counter>(Counter) ??
      container.add<$Counter>(Counter, () {
        final $Counter ret = $Counter(container)..notify();
        return ret;
      }());

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Counter;

  Counter src = Counter();

  @override
  List<Object?> get props => <Object?>[count];

  @override
  int get count => src.count;

  @override
  set count(int val) {
    src.count = val;
    notify();
  }

  @override
  int get nothing => src.nothing;

  @override
  set nothing(int val) {
    src.nothing = val;
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

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }

  @override
  void Function() get forTest => src.forTest;

  @override
  set forTest(void Function() val) {
    src.forTest = val;
    notify();
  }
}
