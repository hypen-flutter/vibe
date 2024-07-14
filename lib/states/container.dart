part of 'states.dart';

/// A simple container maintains the streams
class VibeContainer {
  final Map<dynamic, Stream> _container = {};

  /// Adds new stream
  void add(dynamic key, Stream stream) {
    _container[key] = stream;
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
