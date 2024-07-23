part of 'states.dart';

typedef VibeFutureOr<T> = FutureOr<T>;

mixin Viber<T> on EquatableMixin {
  final subject = BehaviorSubject<List>();
  final List<Viber> _dependencies = [];
  late final stream = subject
      .where((_) => _refCount != 0)
      .distinct(deepEquals)
      .map<T>((event) => this as T);

  bool get autoDispose;
  VibeContainer get container;
  dynamic get key;

  int _refCount = 0;

  @nonVirtual
  void ref() {
    ++_refCount;
  }

  @nonVirtual
  void unref() {
    --_refCount;
  }

  @nonVirtual
  void notify() {
    subject.add(props);
  }

  @nonVirtual
  void addDependency(Viber v) {
    _dependencies.add(v..ref());
  }

  @mustCallSuper
  void dispose() {
    for (final d in _dependencies) {
      d.unref();
    }
    _dependencies.clear();
    if (autoDispose && _refCount == 0) {
      container.remove(key);
    }
  }
}
