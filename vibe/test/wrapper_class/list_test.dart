import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/wrapper_class/list.dart';

int main() {
  group('VibeList', () {
    late VibeList list;
    late _Callback callback;
    setUp(() {
      callback = _Callback();
      list = VibeList(<int>[], callback.call);
    });

    void prepare() {
      callback.callback = expectAsync0(() {});
    }

    test('add can notify', () {
      prepare();
      list.add(10);
    });
    test('remove can notify', () {
      list.add(10);
      prepare();
      list.remove(10);
    });
    test('addAll can notify', () {
      prepare();
      list.addAll(<int>[1, 2, 3, 4]);
    });
    test('change element can notify', () {
      list.add(1);
      prepare();
      list[0] = 2;
    });
  });
  return 0;
}

class _Callback {
  _Callback();
  void Function()? callback;
  void call() => callback?.call();
}
