// ignore_for_file: cascade_invocations
part of 'enum_example.dart';

class HomeTabState with VibeEquatableMixin, Viber<HomeTabState> {
  HomeTabState._(this.container);

  factory HomeTabState.find(VibeContainer container,
      {HomeTab src = HomeTab.main, bool overrides = false}) {
    HomeTabState? ret =
        overrides ? null : container.find<HomeTabState>(HomeTab);
    if (ret != null) {
      return ret;
    }
    ret = HomeTabState._(container)
      .._src = src
      ..notify();

    container.add<HomeTabState>(HomeTab, ret, overrides: overrides);
    return ret;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get $effectKey => HomeTab;

  @override
  late dynamic $key = HomeTab;

  List<HomeTabEffect> get effects => (container.findEffects($effectKey) ?? [])
      .map((e) => e as HomeTabEffect)
      .toList();

  HomeTab _src = HomeTab.main;
  HomeTab get state => _src;
  set state(HomeTab val) {
    _src = val;
    Future(() {
      effects.forEach((e) => e.didHomeTabChanged(this));
    });
    notify();
  }

  @override
  List<Object?> get props => <Object?>[_src];

  bool get ismain => state == HomeTab.main;

  bool get isfind => state == HomeTab.find;

  bool get issettings => state == HomeTab.settings;

  T map<T>({
    T Function(HomeTabState vibe)? onMain,
    T Function(HomeTabState vibe)? onFind,
    T Function(HomeTabState vibe)? onSettings,
    T Function(HomeTabState vibe)? orElse,
  }) {
    assert(
        (onMain != null && onFind != null && onSettings != null) ||
            orElse != null,
        'You must provide at least [orElse]');
    return switch (state) {
      HomeTab.main => onMain?.call(this) ?? orElse!(this),
      HomeTab.find => onFind?.call(this) ?? orElse!(this),
      HomeTab.settings => onSettings?.call(this) ?? orElse!(this)
    };
  }

  void toMain() {
    state = HomeTab.main;
  }

  void toFind() {
    state = HomeTab.find;
  }

  void toSettings() {
    state = HomeTab.settings;
  }
}

extension HomeTabToVibe on HomeTab {
  HomeTabState Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) =>
          HomeTabState.find(container, src: this, overrides: override);
}

mixin HomeTabEffect on VibeEffect {
  @override
  void init() {
    addKey(HomeTab);
  }

  Future<void> didHomeTabChanged(HomeTabState vibe) async {}
}
