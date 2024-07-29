import 'package:vibe/vibe.dart';

part "infinity.vibe.dart";

@Vibe()
class Infinity with _Infinity {
  Infinity();
  @Computed()
  external factory Infinity.fromRemote();
}

class LoadInfinity extends VibeEffect with ComputeInfinityFromRemote {
  @override
  Future<Infinity> computeInfinityFromRemote() async {
    await Future.delayed(const Duration(seconds: 20));
    return Infinity();
  }
}
