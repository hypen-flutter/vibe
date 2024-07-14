part of 'current_user.dart';

T findOrInsert<T>(
    VibeContainer vc, T Function(BehaviorSubject<T> subject) init) {
  var ret = vc.find<T>(T);
  if (ret == null) {
    ret = BehaviorSubject<T>();
    vc.insert(T, ret);
    final first = init(ret);
    ret.add(first);
  }
  return ret.value;
}

BehaviorSubject<T> findSubjectOrInsert<T>(
    VibeContainer vc, T Function(BehaviorSubject<T> subject) init) {
  var ret = vc.find<T>(T);
  if (ret == null) {
    ret = BehaviorSubject<T>();
    vc.insert(T, ret);
    final first = init(ret);
    ret.add(first);
  }
  return ret;
}

class $Counter with Viber, Vibee implements Counter {
  factory $Counter(VibeContainer vc) {
    return findOrInsert(vc, (subject) => $Counter._(subject));
  }

  static BehaviorSubject<Counter> getSubject(VibeContainer vc) {
    return findSubjectOrInsert(vc, (subject) => $Counter._(subject));
  }

  $Counter._(this.subject);

  @override
  final BehaviorSubject<Counter> subject;

  Counter src = Counter();

  @override
  int get count {
    registerField<int>(#count);
    return src.count;
  }

  @override
  set count(newVal) {
    src.count = newVal;
    notifyField(#count, newVal);
    notifySubject();
  }

  @override
  void decrease() => src.decrease();

  @override
  void increase() => src.increase();
}

mixin _DerivedVibe {
  int _selectCount(Counter counter);

  Stream<int> _streamDebouncedCount(Stream<Counter> counter);
}

class $PureVibe with Viber, Vibee implements Derived {
  factory $PureVibe(VibeContainer vc) {
    final counter = $Counter.getSubject(vc);
    return findOrInsert(vc, (subject) => $PureVibe._(subject, counter));
  }

  $PureVibe._(this.subject, BehaviorSubject<Counter> counter) {
    final firstCount = _selectCount(counter.value);
    final firstDebouncedCount = _streamDebouncedCount();
  }

  @override
  final BehaviorSubject<Derived> subject;
  Derived src = Derived();
  List<void Function()> onDisposes = [];

  @override
  int get a {
    // wire a only
    return src.a;
  }

  @override
  set a(newVal) {
    // notify
    src.a = newVal;
  }

  // NotTrack
  @override
  int get b => src.b;
  @override
  set b(newVal) => src.b = newVal;

  late final $Counter _counter;

  // @LinkVibe
  @override
  Counter get counter {
    // wire counter only
    // wire counter vibe nestedly
    _counter.setVibee(this);
    return _counter;
  }

  @override
  set counter(newVal) {
    // notify
    src.counter = newVal;
  }

  // @SelectVibe
  @override
  int get count {
    // wire count only
    return src.count;
  }

  // set 을 못하게 막아야 할 수도 있음.
  @override
  set count(newVal) {
    // notify
    src.count = newVal;
  }

  // @StreamVibe
  @override
  int get debouncedCount {
    // wire dc only
    return src.debouncedCount;
  }

  // set 을 못하게 막아야 할 수도 있음.
  @override
  set debouncedCount(newVal) {
    // notify
    src.debouncedCount = newVal;
  }
  
  @override
  VibeFutureOr<int> _selectCount(Counter counter) => src.
  
  @override
  Stream<int> _streamDebouncedCount(Stream<Counter> counter) {
    // TODO: implement _streamDebouncedCount
    throw UnimplementedError();
  }
}
