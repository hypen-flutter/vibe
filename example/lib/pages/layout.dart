import 'package:vibe/vibe.dart';

class VibeLayout {}

@WithVibe([])
class RootLayout extends VibeLayout {
  @Computed()
  external factory RootLayout.hello();
}
