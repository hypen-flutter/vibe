import 'package:vibe/vibe.dart';

class RemoteAPI {}

@Vibe()
class User with _User {
  // 로딩에 필요한 다른 vibe 인젝션
  @Loader(<dynamic>[RemoteAPI])
  User(this.userId);

  final int userId;

  int count = 0;

  @override
  Future<void> $loadNewUser(int userId, RemoteAPI api) async {
    return;

    // remote 에서 데이터를 채우는 작업
  }
}

mixin _User {
  Future<void> $loadNewUser(int userId, RemoteAPI api);
}

class $UserKey with VibeEquatableMixin {
  const $UserKey(this.userId);

  final int userId;

  @override
  List<Object?> get props => <Object?>[userId];
}

extension CreateUserKey on User {
  $UserKey key() => $UserKey(userId);
}

class $User with VibeEquatableMixin, Viber<$User> implements User {
  $User(this.container);
  static $User findUserNew(VibeContainer container, int userId) {
    final $UserKey key = $UserKey(userId);
    return container.find<$User>(key) ??
        container.add<$User>(key, () {
          final $User ret = $User(container);
          final User src = ret.src = User(userId);
          final RemoteAPI api = RemoteAPI(); // 원래는 $RemoteAPI.find(container);
          src.$loadNewUser(userId, api).then((_) {
            ret.notify();
          });
          return ret;
        }());
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => src.key();

  late User src;
  @override
  List<Object?> get props => <Object?>[userId];

  @override
  Future<void> $loadNewUser(int userId, RemoteAPI api) =>
      src.$loadNewUser(userId, api);

  @override
  int get userId => src.userId;

  @override
  int get count => src.count;
  @override
  set count(int val) {
    src.count = val;
    notify();
  }
}

@Vibe()
class Usecase with _Usecase {
  Usecase();
  @LinkVibe(use: User.new)
  User loadUser(int userId) => userNew(userId);
}

mixin _Usecase {
  late final User Function(int userId) userNew;
}

class $Usecase with VibeEquatableMixin, Viber<$Usecase> implements Usecase {
  $Usecase(this.container);

  factory $Usecase.find(VibeContainer container) =>
      container.find<$Usecase>(Usecase) ??
      container.add<$Usecase>(Usecase, () {
        final $Usecase ret = $Usecase(container);
        ret.src.userNew = (int userId) => $User.findUserNew(container, userId);
        ret.notify();
        return ret;
      }());

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Usecase;

  @override
  List<Object?> get props => <Object?>[];

  final Usecase src = Usecase();

  @override
  User Function(int userId) get userNew => src.userNew;

  @override
  User loadUser(int userId) => src.loadUser(userId);

  @override
  set userNew(User Function(int userId) val) {
    src.userNew = val;
  }
}
