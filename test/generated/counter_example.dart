import 'package:equatable/equatable.dart';
import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

@Vibe()
class Counter {
  int count = 0;

  @NotVibe()
  int nothing = 0;
  void increase() => ++count;
  void decrease() => --count;
  void increaseNothing() => ++nothing;
}

class $Counter with EquatableMixin, Viber<$Counter> implements Counter {
  static $Counter find(VibeContainer container) {
    return (container.find<$Counter>(Counter) ??
        container.add<$Counter>(Counter, () {
          final ret = $Counter();
          ret.notify();
          return ret;
        }()));
  }

  Counter src = Counter();
  @override
  List<Object?> get props => [count];

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
}
