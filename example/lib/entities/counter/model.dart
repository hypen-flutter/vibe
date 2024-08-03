import 'package:vibe/vibe.dart';

part 'model.vibe.dart';

@Vibe()
class Counter with _Counter {
  Counter();

  @Computed()
  external factory Counter.byId(int id);

  int count = 0;
  void increase() {
    ++count;
  }

  void decrease() {
    --count;
  }
}
