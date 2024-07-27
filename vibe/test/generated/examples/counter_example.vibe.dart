// ignore_for_file: cascade_invocations
part of 'counter_example.dart';

mixin _Counter implements GeneratedViber<$Counter> {
  @override
  dynamic get $key => Counter;

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
  dynamic get $key => src.$key;

  late Counter src;

  @override
  List<Object?> get props => <Object?>[count, unmodifiable, forTest];

  @override
  int get count => src.count;

  @override
  set count(int val) {
    src.count = val;
    notify();
  }

  @override
  int? get nothing => src.nothing;

  @override
  set nothing(int? val) {
    src.nothing = val;
    notify();
  }

  @override
  int get unmodifiable => src.unmodifiable;

  @override
  void Function() get forTest => src.forTest;

  @override
  set forTest(void Function() val) {
    src.forTest = val;
    notify();
  }

  @override
  void increase() {
    src.increase();
    notify();
  }

  @override
  void decrease() {
    src.decrease();
    notify();
  }

  @override
  void increaseNothing() {
    src.increaseNothing();
    notify();
  }

  @override
  void hoho(int a, int b, int c,
      {required int g, int d = 0, int e = 0, int f = 0}) {
    src.hoho(a, b, c, g: g, d: d, e: e, f: f);
    notify();
  }

  @override
  Future<void> asyncFunction() {
    final Future<void> ret = src.asyncFunction();
    ret.then((_) => notify());

    return ret;
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
