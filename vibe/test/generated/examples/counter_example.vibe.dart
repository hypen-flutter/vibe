// ignore_for_file: cascade_invocations
part of 'counter_example.dart';

mixin _Counter {
  void dispose() {}
}

class $Counter with VibeEquatableMixin, Viber<$Counter> implements Counter {
  $Counter(this.container);

  factory $Counter.find(VibeContainer container) {
    $Counter? ret = container.find<$Counter>(Counter);
    if (ret != null) {
      return ret;
    }
    ret = $Counter(container)..notify();
    container.add<$Counter>(Counter, ret);
    return ret;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Counter;

  Counter src = Counter();

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
  void dispose() {
    src.dispose();
    super.dispose();
  }
}
