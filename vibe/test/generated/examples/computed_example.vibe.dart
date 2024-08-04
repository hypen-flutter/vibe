// ignore_for_file: cascade_invocations
part of 'computed_example.dart';

mixin _Computable implements GeneratedViber<$Computable> {
  @override
  dynamic $key = Computable;

  @override
  dynamic get $effectKey => Computable;

  void dispose() {}

  @override
  $Computable Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) => $Computable
          .find(container, src: this as Computable, overrides: override);
}

class $Computable
    with VibeEquatableMixin, Viber<$Computable>
    implements Computable {
  $Computable(this.container);

  factory $Computable.find(VibeContainer container,
      {Computable? src, bool overrides = false}) {
    src ??= Computable();
    $Computable? ret = container.find<$Computable>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $Computable(container)..src = src;

    ret!.notify();

    container.add<$Computable>(src.$key, ret, overrides: overrides);
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

  List<ComputableEffect> get effects =>
      (container.findEffects($effectKey) ?? [])
          .map((e) => e as ComputableEffect)
          .toList();

  late Computable src;

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
          effect.didComputableIncrease();
        });
      }
    });
  }

  @override
  $Computable Function(VibeContainer container, {bool override}) toVibe() =>
      src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}

mixin ComputableEffect on VibeEffect {
  @override
  void init() {
    addKey(Computable);
  }

  Future<void> didComputableUpdated() async {}
  Future<void> didComputableIncrease() async {}
}

class _ComputableByIdKey with VibeEquatableMixin {
  _ComputableByIdKey(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

mixin ComputeComputableById on VibeEffect {
  @override
  void init() {
    addKey(ComputeComputableById);
  }

  Future<Computable> computeComputableById(int id);
}

class ComputableById extends Computed {
  ComputableById(this.container, {this.parent, this.callback});

  final VibeContainer container;
  final Viber? parent;
  final void Function(Viber v)? callback;

  static dynamic getKey(int id) => _ComputableByIdKey(id);
  static final Map<dynamic, Future> loading = {};

  Future<Computable> call(int id) async {
    final loader = (container.findEffects(ComputeComputableById) ?? [])
        .whereType<ComputeComputableById>()
        .firstOrNull;
    if (loader == null) {
      throw Exception('You did not register [ComputeComputableById].');
    }

    final key = getKey(id);
    final prev = container.find(key);
    if (prev != null) {
      parent?.addDependency(prev);
      await prev.stream.first;
      callback?.call(prev as Viber);
      return prev as Computable;
    }

    final futureSrc = loading[key] ??= loader.computeComputableById(id);
    loading[key] = futureSrc;
    final src = await futureSrc;
    src.$key = key;

    final ret = $Computable.find(container, src: src);
    parent?.addDependency(ret);

    loading.remove(key);

    await ret.stream.first;
    callback?.call(ret);
    return ret;
  }
}

mixin _ComputableUsage implements GeneratedViber<$ComputableUsage> {
  @override
  dynamic $key = ComputableUsage;

  @override
  dynamic get $effectKey => ComputableUsage;

  void dispose() {}

  @override
  $ComputableUsage Function(VibeContainer container, {bool override})
      toVibe() => (VibeContainer container, {bool override = false}) =>
          $ComputableUsage.find(container,
              src: this as ComputableUsage, overrides: override);
}

class $ComputableUsage
    with VibeEquatableMixin, Viber<$ComputableUsage>
    implements ComputableUsage {
  $ComputableUsage(this.container);

  factory $ComputableUsage.find(VibeContainer container,
      {ComputableUsage? src, bool overrides = false}) {
    src ??= ComputableUsage();
    $ComputableUsage? ret = container.find<$ComputableUsage>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $ComputableUsage(container)..src = src;
    src..computableById = ComputableById(container, parent: ret!);
    ret!.notify();

    container.add<$ComputableUsage>(src.$key, ret, overrides: overrides);
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

  List<ComputableUsageEffect> get effects =>
      (container.findEffects($effectKey) ?? [])
          .map((e) => e as ComputableUsageEffect)
          .toList();

  late ComputableUsage src;

  @override
  List<Object?> get props => <Object?>[computableById];

  @override
  ComputableById get computableById => src.computableById;

  @override
  set computableById(ComputableById val) {
    src.computableById = val;
    notify();
  }

  @override
  Future<void> increaseComputable(int id) {
    final Future<void> ret = src.increaseComputable(id);
    ret.then((_) => notify());

    Future(() {
      for (final effect in effects) {
        Future(() {
          effect.didComputableUsageIncreaseComputable(id);
        });
      }
    });

    return ret;
  }

  @override
  $ComputableUsage Function(VibeContainer container, {bool override})
      toVibe() => src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}

mixin ComputableUsageEffect on VibeEffect {
  @override
  void init() {
    addKey(ComputableUsage);
  }

  Future<void> didComputableUsageUpdated() async {}
  Future<void> didComputableUsageIncreaseComputable(int id) async {}
}
