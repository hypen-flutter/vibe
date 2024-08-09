import 'package:flutter/widgets.dart';

mixin BuildTransition {
  Widget buildEnterTransition(Widget page, Animation<double> animation) => page;

  Widget buildCoverTransition(Widget page, Animation<double> animation) => page;

  Widget buildUncoverTransition(Widget page, Animation<double> animation) =>
      page;

  Widget buildExitTransition(Widget page, Animation<double> animation) => page;
}

abstract class VibeLayout with BuildTransition {}

abstract class VibeView with BuildTransition {}

abstract class VibeTemplate with BuildTransition {}
