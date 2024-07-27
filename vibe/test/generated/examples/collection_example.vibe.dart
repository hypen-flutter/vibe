// ignore_for_file: cascade_invocations
part of 'collection_example.dart';

mixin _Collection implements GeneratedViber<$Collection> {
  @override
  dynamic get $key => Collection;

  @override
  dynamic get $effectKey => Collection;

  @override
  dynamic get $loaderKey => Collection;

  void dispose() {}

  @override
  $Collection Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) => $Collection
          .find(container, src: this as Collection, overrides: override);
}

class $Collection
    with VibeEquatableMixin, Viber<$Collection>
    implements Collection {
  $Collection(this.container);

  factory $Collection.find(VibeContainer container,
      {Collection? src, bool overrides = false}) {
    src ??= Collection();
    $Collection? ret = container.find<$Collection>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $Collection(container)..src = src;
    ret!.notify();

    container.add<$Collection>(src.$key, ret, overrides: overrides);
    return ret!;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get $effectKey => src.$effectKey;

  @override
  dynamic get $loaderKey => src.$loaderKey;

  @override
  dynamic get $key => src.$key;

  List<CollectionEffect> get effects =>
      (container.findEffects($effectKey) ?? [])
          .map((e) => e as CollectionEffect)
          .toList();

  late Collection src;

  @override
  List<Object?> get props => <Object?>[list, set, map];

  late VibeList<int> _list = VibeList<int>(src.list, () => notify(force: true));
  @override
  List<int> get list => _list;

  @override
  set list(List<int> val) {
    src.list = val;
    _list = VibeList<int>(val, notify);
    notify();
  }

  late VibeSet<int> _set = VibeSet<int>(src.set, () => notify(force: true));
  @override
  Set<int> get set => _set;

  @override
  set set(Set<int> val) {
    src.set = val;
    _set = VibeSet<int>(val, notify);
    notify();
  }

  late VibeMap<int, int> _map =
      VibeMap<int, int>(src.map, () => notify(force: true));
  @override
  Map<int, int> get map => _map;

  @override
  set map(Map<int, int> val) {
    src.map = val;
    _map = VibeMap<int, int>(val, notify);
    notify();
  }

  @override
  $Collection Function(VibeContainer container, {bool override}) toVibe() =>
      src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}

mixin CollectionEffect on VibeEffect {
  @override
  void init() {
    addKey(Collection);
  }

  Future<void> didCollectionUpdated() async {}
}
