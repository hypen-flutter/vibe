import 'package:flutter/cupertino.dart';

class VibeRoute {
  Future<void> onLinkRequest(BuildContext context) async {}
  Future<void> onExitRequest(BuildContext context) async {}
}

mixin VibeRouteState {
  Future<void> onExitRequest(BuildContext context) async {}
  bool get isVisible;
}
