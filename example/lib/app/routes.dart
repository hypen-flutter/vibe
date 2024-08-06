import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

abstract class VibeRoute {
  void Function()? get onPopRequest => null;
  void Function()? get onPushRequest => null;
}

class HomeRoute extends VibeRoute {
  HomeRoute({
    this.onPopRequest,
    this.onPushRequest,
    this.child,
  });
  @override
  final void Function()? onPopRequest;
  @override
  final void Function()? onPushRequest;
  final VibeRoute? child;
}

@WithVibe([])
class RootRoute extends VibeRoute {
  VibeRoute build(BuildContext context) {
    return HomeRoute(
      onPopRequest: () {},
      child: HomeRoute(),
    );
  }
}
