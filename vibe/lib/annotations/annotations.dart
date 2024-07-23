import 'package:meta/meta_meta.dart';

/// [Vibe] without an argument
const vibe = Vibe();

/// [NotVibe]
const notVibe = NotVibe();

/// [Link] without an argument
const link = LinkVibe();

/// [NoEffect]
const noEffect = NoEffect();

/// Marks a class as it is a reactive state class
@Target({
  TargetKind.classType,
  TargetKind.enumType,
  TargetKind.topLevelVariable,
})
class Vibe {
  const Vibe({this.name, this.willLoad = const [], this.autoDispose = true});

  /// Indicates an alternative name of this [Vibe]
  final Symbol? name;
  final List<Function> willLoad;
  final bool autoDispose;
}

/// Mark a constructor to be used as a loadable [Vibe]
class Loader {
  const Loader([this.requires = const []]);

  /// Dependencies needed while load a data
  final List<dynamic> requires;
}

/// Marks a field as not a reactive field.
@Target({TargetKind.field})
class NotVibe {
  const NotVibe();
}

/// Marks a field to connect it to the other [Vibe] state.
@Target({TargetKind.field, TargetKind.getter, TargetKind.setter})
class LinkVibe {
  const LinkVibe([this.name]);

  /// Indicates an alternative name of the other vibe
  final Symbol? name;
}

/// Marks a field to selectively watch the other [Vibe] state.
class SelectVibe {
  const SelectVibe(this.targets);

  /// List of target [Vibe]s
  final List<dynamic> targets;
}

/// Marks a field to continuely watch the other [Vibe] state.
@Target({TargetKind.field})
class StreamVibe {
  const StreamVibe(this.targets);

  /// List of target [Vibe]s
  final List<dynamic> targets;
}

/// Marks a side effect of other [Vibe]s
@Target({TargetKind.classType})
class VibeEffect {
  const VibeEffect(this.requires);

  /// List of target [Vibe]s
  final List<dynamic> requires;
}

/// Makes code generator not generate side effect code.
@Target({TargetKind.field, TargetKind.method})
class NoEffect {
  const NoEffect();
}
