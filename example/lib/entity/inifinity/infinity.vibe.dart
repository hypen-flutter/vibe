// ignore_for_file: cascade_invocations
part of 'infinity.dart';

mixin _Infinity implements GeneratedViber<$Infinity> {
  @override
  dynamic $key = Infinity;

  @override
  dynamic get $effectKey => Infinity;

  void dispose() {}

  @override
  $Infinity Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) =>
          $Infinity.find(container, src: this as Infinity, overrides: override);
}

class $Infinity with VibeEquatableMixin, Viber<$Infinity> implements Infinity {
  $Infinity(this.container);

  factory $Infinity.find(VibeContainer container,
      {Infinity? src, bool overrides = false}) {
    src ??= Infinity();
    $Infinity? ret = container.find<$Infinity>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $Infinity(container)..src = src;

    ret!.notify();

    container.add<$Infinity>(src.$key, ret, overrides: overrides);
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

  List<InfinityEffect> get effects => (container.findEffects($effectKey) ?? [])
      .map((e) => e as InfinityEffect)
      .toList();

  late Infinity src;

  @override
  List<Object?> get props => <Object?>[];

  @override
  $Infinity Function(VibeContainer container, {bool override}) toVibe() =>
      src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}

mixin InfinityEffect on VibeEffect {
  @override
  void init() {
    addKey(Infinity);
  }

  Future<void> didInfinityUpdated() async {}
}

class _InfinityFromRemoteKey with VibeEquatableMixin {
  _InfinityFromRemoteKey();

  @override
  List<Object?> get props => [];
}

mixin ComputeInfinityFromRemote on VibeEffect {
  @override
  void init() {
    addKey(ComputeInfinityFromRemote);
  }

  Future<Infinity> computeInfinityFromRemote();
}

class InfinityFromRemote extends Computed {
  InfinityFromRemote(this.container, {this.parent, this.callback});

  final VibeContainer container;
  final Viber? parent;
  final void Function(Viber v)? callback;

  static dynamic getKey() => _InfinityFromRemoteKey();
  static final Map<dynamic, Future> loading = {};

  Future<Infinity> call() async {
    final loader = (container.findEffects(ComputeInfinityFromRemote) ?? [])
        .whereType<ComputeInfinityFromRemote>()
        .firstOrNull;
    if (loader == null) {
      throw Exception('You did not register [ComputeInfinityFromRemote].');
    }

    final key = getKey();
    final prev = container.find(key);
    if (prev != null) {
      parent?.addDependency(prev);
      await prev.stream.first;
      callback?.call(prev as Viber);
      return prev as Infinity;
    }

    final futureSrc = loading[key] ??= loader.computeInfinityFromRemote();
    loading[key] = futureSrc;
    final src = await futureSrc;
    src.$key = key;

    final ret = $Infinity.find(container, src: src);
    parent?.addDependency(ret);

    loading.remove(key);

    await ret.stream.first;
    callback?.call(ret);
    return ret;
  }
}
