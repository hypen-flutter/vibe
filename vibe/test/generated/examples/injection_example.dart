import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/streams.dart';
import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

import 'counter_example.dart';

@Vibe()
class Derived with _Derived {
  @LinkVibe()
  late Counter counter;

  @SelectVibe([Counter])
  late int count;

  @StreamVibe([Counter])
  late int streamedCount;

  @override
  VibeFutureOr<int> $selectCount(Counter counter) async {
    return counter.count;
  }

  @override
  Stream<int> $streamStreamedCount(Stream<Counter> counter) {
    return counter.map((c) => c.count).distinct().where((c) => c % 2 == 0);
  }
}

mixin _Derived {
  FutureOr<int> $selectCount(Counter counter);
  Stream<int> $streamStreamedCount(Stream<Counter> counter);
}

class $Derived with EquatableMixin, Viber<$Derived> implements Derived {
  $Derived(this.container);

  static $Derived find(VibeContainer container) {
    return container.find<$Derived>(Derived) ??
        container.add<$Derived>(Derived, () {
          final counter = $Counter.find(container);
          final state = $Derived(container);
          state.addDependency(counter);
          ZipStream([counter.stream], (cs) => cs).first.then(
            (value) async {
              state.src.counter = counter;
              counter.stream
                  .skip(1)
                  .listen((counter) => state.counter = counter);

              state.src.count = await state.$selectCount(counter);
              counter.stream
                  .skip(1)
                  .asyncMap(state.$selectCount)
                  .distinct()
                  .listen((e) {
                state.count = e;
              });

              final streamedCountStream =
                  state.$streamStreamedCount(counter.stream);
              state.src.streamedCount = await streamedCountStream.first;
              streamedCountStream.skip(1).listen((event) {
                state.streamedCount = event;
              });

              state.notify();
            },
          );
          return state;
        }());
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Derived;

  final src = Derived();

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
  Counter get counter => src.counter;

  @override
  int get streamedCount => src.streamedCount;

  @override
  set streamedCount(val) {
    src.streamedCount = val;
    notify();
  }

  @override
  VibeFutureOr<int> $selectCount(Counter counter) => src.$selectCount(counter);

  @override
  Stream<int> $streamStreamedCount(Stream<Counter> counter) =>
      src.$streamStreamedCount(counter);

  @override
  set counter(Counter counter) {
    src.counter = counter;
    notify();
  }
}
