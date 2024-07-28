import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/computed_example.dart';

int main() {
  group('Computable', () {
    late VibeContainer container;
    late ComputableUsage usage;
    setUp(() {
      container = VibeContainer();
      usage = $ComputableUsage.find(container);
    });

    test('[increase] throws error without a loader registered', () async {
      final _ = runZonedGuarded(
        () async {
          await usage.increaseComputable(1);
        },
        (error, stack) {
          expect(error.toString(), contains('You did not register'));
        },
      );
    });
    test('can get named [Computable] when a loader is registered', () async {
      final _ = MyComputableLoader()
        ..init()
        ..register(container);
      final computable = await usage.computableById(1);
      expect(computable.count, equals(1));
    });

    test('sync with a computable', () async {
      final _ = MyComputableLoader()
        ..init()
        ..register(container);
      final computable = await usage.computableById(1);
      await usage.increaseComputable(1);
      expect(computable.count, equals(2));
    });

    test('accessing multiple times return the same src', () async {
      final _ = MyComputableLoader()
        ..init()
        ..register(container);
      final computable = await usage.computableById(1);
      await usage.increaseComputable(1);
      await usage.increaseComputable(1);
      expect(computable.count, equals(3));
    });
  });
  return 0;
}

class MyComputableLoader extends VibeEffect with ComputeComputableById {
  @override
  Future<Computable> computeComputableById(int id) async =>
      Computable()..count = id;
}
