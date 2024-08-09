import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/enum_example.dart';

int main() {
  group('Enum class', () {
    late VibeContainer container;
    late HomeTabState state;
    setUp(() {
      container = VibeContainer();
      state = HomeTabState.find(container);
    });
    test('can return the default state at first', () {
      expect(state.state, equals(HomeTab.main));
    });

    test('can notify change', () async {
      final callback = expectAsync1((_) {});
      state.stream.skip(1).listen(callback);
      state.toFind();
    });

    test('can call effect', () async {
      final callback = expectAsync0(() {});
      final effect = MyEffect(callback);
      container.addEffect(HomeTab, effect);
      state.toFind();
    });
  });
  return 0;
}

class MyEffect extends VibeEffect with HomeTabEffect {
  MyEffect(this.callback);
  final void Function() callback;
  @override
  Future<void> didHomeTabChanged(HomeTabState vibe) async {
    callback();
  }
}
