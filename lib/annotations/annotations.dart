import 'package:meta/meta_meta.dart';

/// Mark a class as it is a reactive state class
@Target({
  TargetKind.classType,
  TargetKind.enumType,
})
class Vibe {
  const Vibe([this.name]);

  /// Indicates an alternative name of this [Vibe]
  final Symbol? name;
}

/// Mark a field as not a reactive field.
@Target({TargetKind.field})
class NotVibe {
  const NotVibe();
}

/// Mark a field to connect it to the other [Vibe] state.
@Target({TargetKind.field})
class LinkVibe {
  const LinkVibe([this.name]);

  /// Indicates an alternative name of the other vibe
  final Symbol? name;
}

/// Mark a field to selectively watch the other [Vibe] state.
@Target({TargetKind.field})
class SelectVibe {
  const SelectVibe(this.targets);

  /// List of target [Vibe]s
  final List<dynamic> targets;
}

/// Mark a field to continuely watch the other [Vibe] state.
@Target({TargetKind.field})
class StreamVibe {
  const StreamVibe(this.targets);

  /// List of target [Vibe]s
  final List<dynamic> targets;
}

/// Mark a side effect of other [Vibe]s
@Target({TargetKind.classType})
class VibeEffect {
  const VibeEffect(this.targets);

  /// List of target [Vibe]s
  final List<dynamic> targets;
}
