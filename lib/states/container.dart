part of 'states.dart';

/// A simple container maintains the streams
class VibeContainer {
  final Map<dynamic, Stream> _container = {};

  /// Adds new stream
  Stream<T> add<T>(dynamic key, Stream<T> stream) {
    return _container[key] = stream;
  }

  /// Returns the stream or null
  Stream<T>? find<T>(dynamic key) {
    return _container[key] as Stream<T>?;
  }

  /// Removes the stream
  Stream<T>? remove<T>(dynamic key) {
    return _container.remove(key) as Stream<T>?;
  }
}
