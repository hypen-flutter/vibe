import 'package:vibe/vibe.dart';

import '../counter/model.dart';
import 'infinity.dart';

part 'intifiniy.api.vibe.dart';

@WithVibe([Counter])
class LoadInfinity extends VibeEffect with ComputeInfinityFromRemote {
  @override
  Future<Infinity> computeInfinityFromRemote() async {
    print(counter.count);
    await Future.delayed(const Duration(seconds: 20));
    return Infinity();
  }
}
