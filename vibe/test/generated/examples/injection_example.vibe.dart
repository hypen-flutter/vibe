// ignore_for_file: cascade_invocations
part of 'injection_example.dart';

mixin _Derived {
  void dispose() {}
  VibeFutureOr<int> $selectCount(Counter counter);

  Stream<int> $streamStreamedCount(Stream<Counter> counter);
}

extension DerivedToVibe on Derived {
  $Derived Function(VibeContainer container) toVibe() =>
      (VibeContainer container) =>
          $Derived.find(container, src: this, overrides: true);
}

class $Derived with VibeEquatableMixin, Viber<$Derived> implements Derived {
  $Derived(this.container);

  factory $Derived.find(VibeContainer container,
      {Derived? src, bool overrides = false}) {
    $Derived? ret = container.find<$Derived>(Derived);
    if (ret != null && !overrides) {
      return ret;
    }
    final $Counter counter = $Counter.find(container);

    ret = $Derived(container)..addDependency(counter);
    ZipStream(<Stream<dynamic>>[counter.stream], (List<dynamic> zs) => zs)
        .first
        .then((List<dynamic> _) async {
      ret!.src.counter = counter;
      ret!.addSubscription(counter.stream
          .skip(1)
          .listen(($Counter counter) => ret!.counter = counter));

      ret!.src.count = await ret!.$selectCount(counter);
      ret!.addSubscription(ZipStream([(counter.stream)], (_) => _)
          .skip(1)
          .asyncMap((_) => ret!.$selectCount(counter))
          .distinct()
          .listen((e) => ret!.count = e));

      final streamedStreamedCount = ret!.$streamStreamedCount(counter.stream);
      ret!.src.streamedCount = await streamedStreamedCount.first;
      ret!.addSubscription(
          streamedStreamedCount.skip(1).listen((e) => ret!.streamedCount = e));

      ret!.notify();
    });

    container.add<$Derived>(Derived, ret, overrides: overrides);
    if (src != null) {
      ret.src = src;
    }
    return ret!;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Derived;

  Derived src = Derived();

  @override
  List<Object?> get props => <Object?>[counter, count, streamedCount];

  @override
  Counter get counter => src.counter;

  @override
  set counter(Counter val) {
    src.counter = val;
    notify();
  }

  @override
  int get count => src.count;

  @override
  set count(int val) {
    src.count = val;
    notify();
  }

  @override
  int get streamedCount => src.streamedCount;

  @override
  set streamedCount(int val) {
    src.streamedCount = val;
    notify();
  }

  @override
  Future<int> $selectCount(Counter counter) {
    final Future<int> ret = src.$selectCount(counter);

    return ret;
  }

  @override
  Stream<int> $streamStreamedCount(Stream<Counter> counter) {
    final Stream<int> ret = src.$streamStreamedCount(counter);

    return ret;
  }

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}
