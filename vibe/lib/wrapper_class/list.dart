import 'dart:math';

import 'callback.dart';

class VibeList<E> implements List<E> {
  VibeList(this.src, this.notify);
  final List<E> src;
  final Callback notify;

  @override
  E get first => src.first;

  @override
  set first(E newVal) {
    src.first = newVal;
    notify();
  }

  @override
  E get last => src.last;

  @override
  set last(E value) {
    src.last = value;
    notify();
  }

  @override
  int get length => src.length;

  @override
  set length(int newVal) => src.length = newVal;

  @override
  List<E> operator +(List<E> other) => src + other;

  @override
  E operator [](int index) => src[index];

  @override
  void operator []=(int index, E value) {
    src[index] = value;
    notify();
  }

  @override
  void add(E value) {
    src.add(value);
    notify();
  }

  @override
  void addAll(Iterable<E> iterable) {
    src.addAll(iterable);
    notify();
  }

  @override
  bool any(bool Function(E element) test) => src.any(test);

  @override
  Map<int, E> asMap() => src.asMap();

  @override
  List<R> cast<R>() => src.cast();

  @override
  void clear() {
    src.clear();
    notify();
  }

  @override
  bool contains(Object? element) => src.contains(element);

  @override
  E elementAt(int index) => src.elementAt(index);

  @override
  bool every(bool Function(E element) test) => src.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) =>
      src.expand(toElements);

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    src.fillRange(start, end, fillValue);
    notify();
  }

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
  Iterable<E> getRange(int start, int end) => src.getRange(start, end);

  @override
  int indexOf(E element, [int start = 0]) => src.indexOf(element, start);

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) =>
      src.indexWhere(test, start);

  @override
  void insert(int index, E element) {
    src.insert(index, element);
    notify();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    src.insertAll(index, iterable);
    notify();
  }

  @override
  bool get isEmpty => src.isEmpty;

  @override
  bool get isNotEmpty => src.isNotEmpty;

  @override
  Iterator<E> get iterator => src.iterator;

  @override
  String join([String separator = '']) => src.join(separator);

  @override
  int lastIndexOf(E element, [int? start]) => src.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) =>
      src.lastIndexWhere(test, start);

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) =>
      src.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E e) toElement) => src.map(toElement);

  @override
  E reduce(E Function(E value, E element) combine) => src.reduce(combine);

  @override
  bool remove(Object? value) {
    final bool ret = src.remove(value);
    notify();
    return ret;
  }

  @override
  E removeAt(int index) {
    final E ret = src.removeAt(index);
    notify();
    return ret;
  }

  @override
  E removeLast() {
    final E ret = src.removeLast();
    notify();
    return ret;
  }

  @override
  void removeRange(int start, int end) {
    src.removeRange(start, end);
    notify();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    src.removeWhere(test);
    notify();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    src.replaceRange(start, end, replacements);
    notify();
  }

  @override
  void retainWhere(bool Function(E element) test) {
    src.retainWhere(test);
    notify();
  }

  @override
  Iterable<E> get reversed => src.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    src.setAll(index, iterable);
    notify();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    src.setRange(start, end, iterable, skipCount);
    notify();
  }

  @override
  void shuffle([Random? random]) {
    src.shuffle(random);
    notify();
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
  void sort([int Function(E a, E b)? compare]) {
    src.sort(compare);
    notify();
  }

  @override
  List<E> sublist(int start, [int? end]) => src.sublist(start, end);

  @override
  Iterable<E> take(int count) => src.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => src.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => src.toList(growable: growable);

  @override
  Set<E> toSet() => src.toSet();

  @override
  Iterable<E> where(bool Function(E element) test) => src.where(test);

  @override
  Iterable<T> whereType<T>() => src.whereType();
}
