import 'package:vibe/vibe.dart';

@Vibe()
enum HomeState {
  main,
  find,
  settings;
}

extension HomeStateToVibe on HomeState {
  HomeStateVibe Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) =>
          HomeStateVibe.find(container, src: this, overrides: override);
}

class HomeStateVibe with VibeEquatableMixin, Viber<HomeStateVibe> {
  HomeStateVibe._();

  factory HomeStateVibe.find(VibeContainer container,
      {HomeState src = HomeState.main, bool overrides = false}) {
    HomeStateVibe? ret =
        overrides ? null : container.find(HomeState) as HomeStateVibe?;

    if (ret != null) {
      return ret;
    }
    ret = HomeStateVibe._()
      ..container = container
      .._state = src
      ..notify();

    container.add<HomeStateVibe>(HomeState, ret, overrides: overrides);
    return ret;
  }

  @override
  Type get $key => HomeState;

  @override
  bool get autoDispose => true;

  @override
  late final VibeContainer container;

  @override
  List<Object?> get props => [_state];

  HomeState _state = HomeState.main;

  HomeState get state => _state;

  set state(HomeState val) {
    _state = val;
    notify();
  }

  bool get isMain => state == HomeState.main;
  bool get isFind => state == HomeState.find;
  bool get isSettings => state == HomeState.settings;

  T map<T>({
    T Function(HomeStateVibe vibe)? onMain,
    T Function(HomeStateVibe vibe)? onFind,
    T Function(HomeStateVibe vibe)? onSettings,
    T Function(HomeStateVibe vibe)? orElse,
  }) {
    assert(
        (onMain != null && onFind != null && onSettings != null) ||
            orElse != null,
        'You must provide at least [orElse]');
    return switch (state) {
      HomeState.main => onMain?.call(this) ?? orElse!(this),
      HomeState.find => onFind?.call(this) ?? orElse!(this),
      HomeState.settings => onSettings?.call(this) ?? orElse!(this),
    };
  }

  void toMain() {
    state = HomeState.main;
  }

  void toFind() {
    state = HomeState.find;
  }

  void toSettings() {
    state = HomeState.settings;
  }
}

mixin HomeStateEffect on VibeEffect {
  @override
  void init() {
    addKey(HomeState);
  }

  Future<void> didHomeStateChangedToMain();
  Future<void> didHomeStateChangedToFind();
  Future<void> didHomeStateChangedToSettings();
}
