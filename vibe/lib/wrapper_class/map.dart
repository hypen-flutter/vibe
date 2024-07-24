import 'callback.dart';

class VibeMap<K, V> implements Map<K, V> {
  const VibeMap(this.src, this.notify);
  final Map<K, V> src;
  final Callback notify;

  @override
  V? operator [](Object? key) => src[key];

  @override
  void operator []=(K key, V value) {
    src[key] = value;
    notify();
  }

  @override
  void addAll(Map<K, V> other) {
    src.addAll(other);
    notify();
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    src.addEntries(newEntries);
    notify();
  }

  @override
  Map<RK, RV> cast<RK, RV>() => src.cast();

  @override
  void clear() {
    src.clear();
    notify();
  }

  @override
  bool containsKey(Object? key) => src.containsKey(key);

  @override
  bool containsValue(Object? value) => src.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => src.entries;

  @override
  void forEach(void Function(K key, V value) action) => src.forEach(action);

  @override
  bool get isEmpty => src.isEmpty;

  @override
  bool get isNotEmpty => src.isNotEmpty;

  @override
  Iterable<K> get keys => src.keys;

  @override
  int get length => src.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) =>
      src.map(convert);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    late V ret;
    _notifyWhenChanged(() {
      ret = src.putIfAbsent(key, ifAbsent);
    });
    return ret;
  }

  @override
  V? remove(Object? key) {
    final ret = src.remove(key);
    notify();
    return ret;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _notifyWhenChanged(() {
      src.removeWhere(test);
    });
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final ret = src.update(key, update, ifAbsent: ifAbsent);
    notify();
    return ret;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    src.updateAll(update);
    notify();
  }

  @override
  Iterable<V> get values => src.values;

  void _notifyWhenChanged(void Function() callback) {
    final int len = length;
    callback();
    final int afterLen = length;
    if (len != afterLen) {
      notify();
    }
  }
}
