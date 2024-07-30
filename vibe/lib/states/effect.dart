import '../vibe.dart';

/// SideEffect of [Vibe]
abstract class VibeEffect {
  final Set<dynamic> _effectKeys = {};
  late VibeContainer $container;

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
    $container = container;
    for (final key in _effectKeys) {
      container.addEffect(key, this);
    }
  }
}
