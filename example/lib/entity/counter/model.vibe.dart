// ignore_for_file: cascade_invocations
part of 'model.dart';

mixin _Counter implements GeneratedViber<$Counter> {
  @override
  dynamic $key = Counter;

  @override
  dynamic get $effectKey => Counter;

  void dispose() {}

  @override
  $Counter Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) =>
          $Counter.find(container, src: this as Counter, overrides: override);
}

class $Counter with VibeEquatableMixin, Viber<$Counter> implements Counter {
  $Counter(this.container);

  factory $Counter.find(VibeContainer container,
      {Counter? src, bool overrides = false}) {
    src ??= Counter();
    $Counter? ret = container.find<$Counter>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $Counter(container)..src = src;

    ret!.notify();

    container.add<$Counter>(src.$key, ret, overrides: overrides);
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

  List<CounterEffect> get effects => (container.findEffects($effectKey) ?? [])
      .map((e) => e as CounterEffect)
      .toList();

  late Counter src;

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
  void increase() {
    src.increase();
    notify();

    Future(() {
      for (final effect in effects) {
        Future(() {
          effect.didCounterIncrease();
        });
      }
    });
  }

  @override
  void decrease() {
    src.decrease();
    notify();

    Future(() {
      for (final effect in effects) {
        Future(() {
          effect.didCounterDecrease();
        });
      }
    });
  }

  @override
  $Counter Function(VibeContainer container, {bool override}) toVibe() =>
      src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}

mixin CounterEffect on VibeEffect {
  @override
  void init() {
    addKey(Counter);
  }

  Future<void> didCounterUpdated() async {}
  Future<void> didCounterIncrease() async {}

  Future<void> didCounterDecrease() async {}
}

class _CounterByIdKey with VibeEquatableMixin {
  _CounterByIdKey(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

mixin ComputeCounterById on VibeEffect {
  @override
  void init() {
    addKey(ComputeCounterById);
  }

  Future<Counter> computeCounterById(int id);
}

class CounterById extends Computed {
  CounterById(this.container, {this.parent, this.callback});

  final VibeContainer container;
  final Viber? parent;
  final void Function(Viber v)? callback;

  static dynamic getKey(int id) => _CounterByIdKey(id);
  static final Map<dynamic, Future> loading = {};

  Future<Counter> call(int id) async {
    final loader = (container.findEffects(ComputeCounterById) ?? [])
        .whereType<ComputeCounterById>()
        .firstOrNull;
    if (loader == null) {
      throw Exception('You did not register [ComputeCounterById].');
    }

    final key = getKey(id);
    final prev = container.find(key);
    if (prev != null) {
      parent?.addDependency(prev);
      await prev.stream.first;
      callback?.call(prev as Viber);
      return prev as Counter;
    }

    final futureSrc = loading[key] ??= loader.computeCounterById(id);
    loading[key] = futureSrc;
    final src = await futureSrc;
    src.$key = key;

    final ret = $Counter.find(container, src: src);
    parent?.addDependency(ret);

    loading.remove(key);

    await ret.stream.first;
    callback?.call(ret);
    return ret;
  }
}
