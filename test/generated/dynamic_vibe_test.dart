import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/states/states.dart';

import 'examples/dynamic_example.dart';

int main() {
  group('[Usecase]', () {
    late VibeContainer container;
    late Usecase usecase;

    setUp(() {
      container = VibeContainer();
      usecase = $Usecase.find(container);
    });

    test('dynamically loads [User]', () {
      final user = usecase.loadUser(0);
      expect(user, isA<User>());
    });

    test('returns a user with the same id', () {
      for (int i = 0; i < 100; ++i) {
        final user = usecase.loadUser(0);
        expect(user.userId, equals(0));
      }
    });

    test('returns the same user when called multiple times with the same id',
        () {
      final u1 = usecase.loadUser(0);
      final u2 = usecase.loadUser(0);
      expect(u1, equals(u2));
    });

    test('returns the same user with the separately loaded user', () {
      final u1 = usecase.loadUser(0);
      final u2 = $User.findUserNew(container, 0);

      expect(u1, equals(u2));
    });

    test('a returned user works as same as the separately loaded user', () {
      final u1 = usecase.loadUser(0);
      final u2 = $User.findUserNew(container, 0);
      u2.count++;
      expect(u1.count, equals(u2.count));
    });

    test('a separately loaded user works as same as the returned user', () {
      final u1 = usecase.loadUser(0);
      final u2 = $User.findUserNew(container, 0);
      u1.count++;
      expect(u2.count, equals(u1.count));
    });
  });
  return 0;
}
