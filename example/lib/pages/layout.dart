import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

class VibeLayout {
  Widget buildEnterTransition(Widget page) {
    return page;
  }

  Widget buildPushedTransition(Widget page) {
    return page;
  }

  Widget buildPoppedTransition(Widget page) {
    return page;
  }

  Widget buildExitTransition(Widget page) {
    return page;
  }
}

@WithVibe([])
class RootLayout extends VibeLayout {
  @Computed()
  external factory RootLayout.hello();
}
