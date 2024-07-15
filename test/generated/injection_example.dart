import 'package:equatable/equatable.dart';
import 'package:rxdart/subjects.dart';
import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

import '../states/container_test.dart';
import '../states/equals.dart';
import 'counter_example.dart';

@Vibe()
class Derived with _Derived {
  @LinkVibe()
  late Counter counter;

  @SelectVibe([Counter])
  late int count;

  @StreamVibe([Counter])
  late int streamedCount;
}

mixin _Derived {
  int selec
}

class $Derived with EquatableMixin implements Derived {
  static Stream<Derived> find(VibeContainer container) {
    final counterStream = $Counter.find(container);

  }

  $Derived();

  final subject = BehaviorSubject<List>();
  late final stream =
      subject.distinct(deepEquals).map((event) => this);

  final src = Derived();

  void notify() {
    subject.add(props);
  }

  @override
  List<Object?> get props => [counter, count, streamedCount];

  @override
  int get count => src.count;

  @override
  set count(val) {
    src.count = val;
    notify();
  }

  @override
  late Counter counter;

  @override
  int selec;

  @override
  int streamedCount;
  
  @override
  set count(int count) {
    // TODO: implement count
  }
  
}
 