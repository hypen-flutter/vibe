// ignore_for_file: cascade_invocations
part of 'injection_example.dart';

mixin _Derived implements GeneratedViber<$Derived> {
  @override
  dynamic $key = Derived;

  @override
  dynamic get $effectKey => Derived;

  void dispose() {}
  VibeFutureOr<int> $selectCount(Counter counter);

  Stream<int> $streamStreamedCount(Stream<Counter> counter);

  @override
  $Derived Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) =>
          $Derived.find(container, src: this as Derived, overrides: override);
}

class $Derived with VibeEquatableMixin, Viber<$Derived> implements Derived {
  $Derived(this.container);

  factory $Derived.find(VibeContainer container,
      {Derived? src, bool overrides = false}) {
    src ??= Derived();
    $Derived? ret = container.find<$Derived>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $Derived(container)..src = src;

    final $Counter counter = $Counter.find(container);

    ret..addDependency(counter);
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

    container.add<$Derived>(src.$key, ret, overrides: overrides);
    return ret!;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get $effectKey => src.$effectKey;

  @override
  late dynamic $key = src.$key;

  List<DerivedEffect> get effects => (container.findEffects($effectKey) ?? [])
      .map((e) => e as DerivedEffect)
      .toList();

  late Derived src;

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
  $Derived Function(VibeContainer container, {bool override}) toVibe() =>
      src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}

mixin DerivedEffect on VibeEffect {
  @override
  void init() {
    addKey(Derived);
  }

  Future<void> didDerivedUpdated() async {}
}
