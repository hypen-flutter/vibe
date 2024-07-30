import 'package:vibe/vibe.dart';

part 'infinity.vibe.dart';

@Vibe()
class Infinity with _Infinity {
  Infinity();
  @Computed()
  external factory Infinity.fromRemote();
}
