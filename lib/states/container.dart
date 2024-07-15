part of 'states.dart';

/// A simple container maintains the streams
class VibeContainer {
  final Map<dynamic, dynamic> _container = {};

  /// Adds new stream
  T add<T>(dynamic key, T val) {
    return _container[key] = val;
  }

  /// Returns the stream or null
  T? find<T>(dynamic key) {
    return _container[key] as T?;
  }

  /// Removes the stream
  T? remove<T>(dynamic key) {
    return _container.remove(key) as T?;
  }
}
