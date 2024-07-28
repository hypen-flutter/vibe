import 'package:vibe/vibe.dart';

part 'computed_example.vibe.dart';

@Vibe()
class Computable with _Computable {
  Computable();

  @Computed()
  external Computable.byId(int id);

  int count = 0;
  void increase() {
    ++count;
  }
}

@Vibe()
class ComputableUsage with _ComputableUsage {
  @LinkComputed()
  late ComputableById computableById;

  Future<void> increaseComputable(int id) async {
    final computable = await computableById(id);
    computable.increase();
  }
}

class MyComputableLoader extends VibeEffect with ComputeComputableById {
  @override
  Future<Computable> computeComputableById(int id) async =>
      Computable()..count = id;
}
