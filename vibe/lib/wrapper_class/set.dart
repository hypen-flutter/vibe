import 'callback.dart';

class VibeSet<E> implements Set<E> {
  VibeSet(this.src, this.notify);
  final Set<E> src;
  final Callback notify;

  @override
  bool add(E value) {
    final bool ret = src.add(value);
    if (ret) {
      notify();
    }
    return ret;
  }

  @override
  void addAll(Iterable<E> elements) {
    src.addAll(elements);
    notify();
  }

  @override
  bool any(bool Function(E element) test) => src.any(test);

  @override
  Set<R> cast<R>() => src.cast();

  @override
  void clear() {
    src.clear();
    notify();
  }

  @override
  bool contains(Object? value) => src.contains(value);

  @override
  bool containsAll(Iterable<Object?> other) => src.containsAll(other);

  @override
  Set<E> difference(Set<Object?> other) => src.difference(other);

  @override
  E elementAt(int index) => src.elementAt(index);

  @override
  bool every(bool Function(E element) test) => src.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) =>
      src.expand(toElements);

  @override
  E get first => src.first;

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) =>
      src.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      src.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => src.followedBy(other);

  @override
  void forEach(void Function(E element) action) => src.forEach(action);

  @override
  Set<E> intersection(Set<Object?> other) => src.intersection(other);

  @override
  bool get isEmpty => src.isEmpty;

  @override
  bool get isNotEmpty => src.isNotEmpty;

  @override
  Iterator<E> get iterator => src.iterator;

  @override
  String join([String separator = '']) => src.join(separator);

  @override
  E get last => src.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) =>
      src.lastWhere(test, orElse: orElse);

  @override
  int get length => src.length;

  @override
  E? lookup(Object? object) => src.lookup(object);

  @override
  Iterable<T> map<T>(T Function(E e) toElement) => src.map(toElement);

  @override
  E reduce(E Function(E value, E element) combine) => src.reduce(combine);

  @override
  bool remove(Object? value) {
    final bool ret = src.remove(value);
    if (ret) {
      notify();
    }
    return ret;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _notifyWhenChanged(() {
      src.removeAll(elements);
    });
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _notifyWhenChanged(() {
      src.removeWhere(test);
    });
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _notifyWhenChanged(() {
      src.retainAll(elements);
    });
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _notifyWhenChanged(() {
      src.retainWhere(test);
    });
  }

  @override
  E get single => src.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) =>
      src.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => src.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => src.skipWhile(test);

  @override
  Iterable<E> take(int count) => src.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => src.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => src.toList();

  @override
  Set<E> toSet() => src.toSet();

  @override
  Set<E> union(Set<E> other) => src.union(other);

  @override
  Iterable<E> where(bool Function(E element) test) => src.where(test);

  @override
  Iterable<T> whereType<T>() => src.whereType();

  void _notifyWhenChanged(void Function() callback) {
    final int len = length;
    callback();
    final int afterLen = length;
    if (len != afterLen) {
      notify();
    }
  }
}
