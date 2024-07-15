import 'package:equatable/equatable.dart';
import 'package:rxdart/subjects.dart';
import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

import '../states/equals.dart';

@Vibe()
class Counter {
  int count = 0;

  @NotVibe()
  int nothing = 0;
  void increase() => ++count;
  void decrease() => --count;
  void increaseNothing() => ++nothing;
}

class $Counter with EquatableMixin implements Counter {
  static $Counter find(VibeContainer container) {
    return (container.find<$Counter>(Counter) ??
        container.add<$Counter>(Counter, () {
          final ret = $Counter();
          ret.notify();
          return ret;
        }()));
  }

  final subject = BehaviorSubject<List>();
  late final stream = subject.distinct(deepEquals).map((event) => this);

  Counter src = Counter();

  @override
  List<Object?> get props => [count];

  void notify() {
    subject.add(props);
  }

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
