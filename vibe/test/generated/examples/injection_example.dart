import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/streams.dart';
import 'package:vibe/annotations/state_annotations.dart';
import 'package:vibe/states/states.dart';

import 'counter_example.dart';

@Vibe()
class Derived with _Derived {
  @LinkVibe()
  late Counter counter;

  @SelectVibe(<dynamic>[Counter])
  late int count;

  @StreamVibe(<dynamic>[Counter])
  late int streamedCount;

  @override
  VibeFutureOr<int> $selectCount(Counter counter) async => counter.count;

  @override
  Stream<int> $streamStreamedCount(Stream<Counter> counter) =>
      counter.map((Counter c) => c.count).distinct().where((int c) => c.isEven);
}

mixin _Derived {
  FutureOr<int> $selectCount(Counter counter);
  Stream<int> $streamStreamedCount(Stream<Counter> counter);
}

class $Derived with EquatableMixin, Viber<$Derived> implements Derived {
  $Derived(this.container);

  static $Derived find(VibeContainer container) =>
      container.find<$Derived>(Derived) ??
      container.add<$Derived>(Derived, () {
        final $Counter counter = $Counter.find(container);
        final $Derived state = $Derived(container)..addDependency(counter);
        ZipStream(<Stream<$Counter>>[counter.stream], (List<$Counter> cs) => cs)
            .first
            .then(
          (List<$Counter> value) async {
            state.src.counter = counter;
            counter.stream
                .skip(1)
                .listen(($Counter counter) => state.counter = counter);

            state.src.count = await state.$selectCount(counter);
            counter.stream
                .skip(1)
                .asyncMap(state.$selectCount)
                .distinct()
                .listen((int e) {
              state.count = e;
            });

            final Stream<int> streamedCountStream =
                state.$streamStreamedCount(counter.stream);
            state.src.streamedCount = await streamedCountStream.first;
            streamedCountStream.skip(1).listen((int event) {
              state.streamedCount = event;
            });

            state.notify();
          },
        );
        return state;
      }());

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Derived;

  final Derived src = Derived();

  @override
  List<Object?> get props => <Object?>[counter, count, streamedCount];

  @override
  int get count => src.count;

  @override
  set count(int val) {
    src.count = val;
    notify();
  }

  @override
  Counter get counter => src.counter;

  @override
  int get streamedCount => src.streamedCount;

  @override
  set streamedCount(int val) {
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
