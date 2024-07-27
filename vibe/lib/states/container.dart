import '../vibe.dart';

/// A simple container maintains the streams
class VibeContainer {
  VibeContainer({this.parent});
  VibeContainer? parent;
  final Map<dynamic, dynamic> _container = {};
  final Map<dynamic, List<VibeEffect>> _effectContainer = {};

  /// Adds new stream
  T add<T>(dynamic key, T val, {bool overrides = false}) {
    if (!overrides && parent != null) {
      return parent!.add(key, val);
    }
    return _container[key] = val;
  }

  /// Returns the stream or null
  T? find<T>(dynamic key) => (_container[key] ?? parent?.find(key)) as T?;

  /// Removes the stream
  T? remove<T>(dynamic key) {
    final removed = _container.remove(key);
    if (removed != null) {
      return removed;
    }
    return parent?.remove(key);
  }

  /// Adds [VibeEffect]
  void addEffect(dynamic key, VibeEffect effect) {
    (_effectContainer[key] ??= []).add(effect);
  }

  /// Finds all [VibeEffect]s
  List<VibeEffect>? findEffects(dynamic key) => _effectContainer[key];

  /// Remove [VibeEffect]
  void removeEffect(dynamic key, VibeEffect effect) {
    _effectContainer[key]?.remove(effect);
  }

  void dispose() {
    _effectContainer.clear();
    _container.clear();
  }
}
