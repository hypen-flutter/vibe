import 'package:flutter/cupertino.dart';
import 'package:vibe/vibe.dart';

import '../../entities/counter/model.dart';

@WithVibe([Counter])
class HomeRoute extends VibeRoute {
  @override
  Future<void> onExitRequest(BuildContext context) {
    // TODO: implement onExit
    return super.onExitRequest(context);
  }

  @override
  Future<void> onLinkRequest(BuildContext context) {
    // TODO: implement onExit
    return super.onLinkRequest(context);
  }

  List<Type> build(BuildContext context) {
    return [];
  }
}
