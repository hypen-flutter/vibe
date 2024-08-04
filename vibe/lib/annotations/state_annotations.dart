import 'dart:io';

import 'package:meta/meta_meta.dart';

/// [Vibe] without an argument
const Vibe vibe = Vibe();

/// [NotVibe]
const NotVibe notVibe = NotVibe();

/// [Link] without an argument
const LinkVibe linkVibe = LinkVibe();

/// [Computed] without an argument
const Computed computed = Computed();

/// Marks a class as it is a reactive state class
@Target(<TargetKind>{
  TargetKind.classType,
  TargetKind.enumType,
  TargetKind.topLevelVariable,
  TargetKind.function,
})
class Vibe {
  const Vibe({
    this.autoDispose = true,
  });

  /// Wheter disposing the state automatically
  final bool autoDispose;
}

/// Marks a computable [Vibe]
class Computed {
  const Computed();
}

/// Marks a field as not a reactive field.
@Target(<TargetKind>{TargetKind.field})
class NotVibe {
  const NotVibe();
}

/// Marks a field to connect it to the other [Vibe] state.
@Target(<TargetKind>{
  TargetKind.field,
  TargetKind.getter,
  TargetKind.setter,
  TargetKind.method,
  TargetKind.parameter,
})
class LinkVibe {
  const LinkVibe({this.name, this.use});

  /// Indicates an alternative name of the other vibe
  final Symbol? name;

  /// Constructors to be used
  final Function? use;
}

/// Marks a field to connect it to the other [Computed] state.
@Target(<TargetKind>{
  TargetKind.field,
  TargetKind.getter,
  TargetKind.setter,
  TargetKind.method
})
class LinkComputed {
  /// Default constructor
  const LinkComputed();
}

/// Marks a field to selectively watch the other [Vibe] state.
class SelectVibe {
  const SelectVibe(this.sources);

  /// List of target [Vibe]s
  final List<Type> sources;
}

/// Marks a field to continuely watch the other [Vibe] state.
@Target(<TargetKind>{TargetKind.field})
class StreamVibe {
  const StreamVibe(this.sources);

  /// List of target [Vibe]s
  final List<Type> sources;
}

/// Inject [Vibe] into the widget
@Target({TargetKind.classType})
class WithVibe {
  const WithVibe(this.vibes);
  final List<dynamic> vibes;
}
