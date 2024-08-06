library vibe;

import 'dart:async';

import 'package:equatable/equatable.dart';

export 'annotations/state_annotations.dart';
export 'routes/layout.dart';
export 'routes/router_config.dart';
export 'states/container.dart';
export 'states/effect.dart';
export 'states/equals.dart';
export 'states/viber.dart';
export 'widgets/widgets.dart';
export 'wrapper_class/callback.dart';
export 'wrapper_class/list.dart';
export 'wrapper_class/map.dart';
export 'wrapper_class/set.dart';

typedef VibeEquatableMixin = EquatableMixin;
typedef VibeFutureOr<T> = FutureOr<T>;
