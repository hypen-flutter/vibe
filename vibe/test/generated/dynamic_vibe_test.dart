import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

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
      final User user = usecase.user(0);
      expect(user, isA<User>());
    });

    test('returns a user with the same id', () {
      for (int i = 0; i < 100; ++i) {
        final User user = usecase.user(0);
        expect(user.userId, equals(0));
      }
    });

    test('returns the same user when called multiple times with the same id',
        () {
      final User u1 = usecase.user(0);
      final User u2 = usecase.user(0);
      expect(u1, equals(u2));
    });

    test('returns the same user with the separately loaded user', () {
      final User u1 = usecase.user(0);
      final $User u2 = $User.findUserFromRemote(container, 0);

      expect(u1, equals(u2));
    });
  });
  return 0;
}
