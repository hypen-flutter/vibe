import 'package:vibe/vibe.dart';

class RemoteAPI {}

@Vibe()
class User with _User {
  User(this.userId, this.name);
  // 로딩에 필요한 다른 vibe 인젝션
  @Loader(<Type>[RemoteAPI])
  User.fromRemote(this.userId);

  @Loader(<Type>[RemoteAPI])
  User.created(this.name);

  late final int userId;

  late final String name;

  @override
  Future<User> $userFromRemote(int userId, RemoteAPI api) async =>
      User(userId, 'name');

  @override
  Future<User> $userCreated(String name, RemoteAPI api) {
    throw UnimplementedError();
  }
}

mixin _User {
  Future<User> $userFromRemote(int userId, RemoteAPI api);
  Future<User> $userCreated(String name, RemoteAPI api);
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
  static $User findUserFromRemote(VibeContainer container, int userId) {
    final $UserKey key = $UserKey(userId);
    return container.find<$User>(key) ??
        container.add<$User>(key, () {
          final $User ret = $User(container);
          final User src = ret.src = User.fromRemote(userId);
          // 원래는 $RemoteAPI.find(container);
          // one-time use 니까 ref 하지 않아도 됨.
          final RemoteAPI api = RemoteAPI();
          src.$userFromRemote(userId, api).then((_) {
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
  Future<User> $userFromRemote(int userId, RemoteAPI api) =>
      src.$userFromRemote(userId, api);

  @override
  Future<User> $userCreated(String name, RemoteAPI api) {
    throw UnimplementedError();
  }

  @override
  int get userId => src.userId;

  @override
  set userId(int val) {
    src.userId = val;
    notify();
  }

  @override
  String get name => src.name;
  @override
  set name(String val) {
    src.name = val;
    notify();
  }
}

@Vibe()
class Usecase with _Usecase {
  Usecase();
  @LinkVibe(use: User.fromRemote)
  User user(int userId) => userFromRemote(userId);
}

mixin _Usecase {
  late final User Function(int userId) userFromRemote;
}

class $Usecase with VibeEquatableMixin, Viber<$Usecase> implements Usecase {
  $Usecase(this.container);

  factory $Usecase.find(VibeContainer container) =>
      container.find<$Usecase>(Usecase) ??
      container.add<$Usecase>(Usecase, () {
        final $Usecase ret = $Usecase(container);
        ret.src.userFromRemote = (int userId) {
          final r = $User.findUserFromRemote(container, userId);
          ret.addDependency(r);
          return r;
        };
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
  User Function(int userId) get userFromRemote => src.userFromRemote;

  @override
  User user(int userId) => src.user(userId);

  @override
  set userFromRemote(User Function(int userId) val) {
    src.userFromRemote = val;
  }
}
