import '../vibe.dart';

/// SideEffect of [Vibe]
abstract class VibeEffect {
  final Set<dynamic> _effectKeys = {};

  /// Initializes the effect
  ///
  /// Developers will not use this. Vibe framework automatically calls this.
  void init();

  /// Adds related loaders
  void addKey(dynamic key) {
    _effectKeys.add(key);
  }

  /// Register effect to [VibeContainer]
  void register(VibeContainer container) {
    for (final key in _effectKeys) {
      container.addEffect(key, this);
    }
  }
}
