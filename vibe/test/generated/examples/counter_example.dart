import 'dart:async';

import 'package:vibe/vibe.dart';

part 'counter_example.vibe.dart';

@Vibe()
class Counter with _Counter {
  Counter();

  @Loader()
  factory Counter.fromRemote(int id) => _CounterFromRemote(id);

  int count = 0;

  @NotVibe()
  int? nothing = 0;

  final unmodifiable = 0;

  void increase() => ++count;
  void decrease() => --count;

  void increaseNothing() => nothing = (nothing ?? 0) + 1;

  void hoho(int a, int b, int c,
      {required int g, int d = 0, int e = 0, int f = 0}) {}

  late void Function() forTest = () {};

  Future<void> asyncFunction() async {}

  @override
  void dispose() {
    forTest();
  }
}

class _CounterFromRemote extends Counter with VibeEquatableMixin {
  _CounterFromRemote(this.id);

  final int id;

  @override
  late dynamic $key = this;

  @override
  List<Object?> get props => [_CounterFromRemote, id];
}

mixin CounterFromRemoteLoader on VibeEffect {
  @override
  void init() {
    super.init();
    addLoaderKey(_CounterFromRemote);
  }

  Future<Counter> counterFromRemote(int id);
}

typedef CounterFromRemote = Future<Counter> Function(int id);

class Usecase with _Usecase {
  @LinkVibe(use: Counter.fromRemote)
  late final CounterFromRemote fromRemote;
}

class $Usecase with VibeEquatableMixin, Viber<$Usecase> implements Usecase {
  $Usecase(this.container);

  factory $Usecase.find(VibeContainer container,
      {Usecase? src, bool overrides = false}) {
    src ??= Usecase();

    $Usecase? ret = container.find<$Usecase>(src.$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $Usecase(container)..notify();
    /*
    기본 constructor 가 없으면
    if (src == null) {
      잘못된 호출 / loader 만 사용하세요 
    }
    */
    src.fromRemote = (int id) async {
      // remote 등록하고
      // + add dependency
      final fromRemote =
          _CounterFromRemote(id).toVibe()(container, override: false);
      ret!.addDependency(ret);
      return fromRemote.stream.first;
    };

    container.add<$Usecase>(src.$key, ret, overrides: overrides);
    ret.src = src;
    return ret;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get $key => src.$key;

  late Usecase src;

  @override
  late final CounterFromRemote fromRemote = src.fromRemote;

  @override
  final List<Object?> props = <Object?>[];

  @override
  $Usecase Function(VibeContainer container, {bool override}) toVibe() =>
      src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }

  @override
  set fromRemote(CounterFromRemote val) {
    src.fromRemote = val;
    notify();
  }
}

mixin _Usecase implements GeneratedViber {
  void dispose() {}

  @override
  dynamic get $key => Counter;

  @override
  $Usecase Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) =>
          $Usecase.find(container, src: this as Usecase, overrides: override);
}
