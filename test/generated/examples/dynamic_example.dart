import 'package:equatable/equatable.dart';
import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';

class RemoteAPI {}

@Vibe()
class User with _User {
  // 로딩에 필요한 다른 vibe 인젝션
  @Loader([RemoteAPI])
  User(this.userId);

  final int userId;

  int count = 0;

  @override
  VibeFutureOr<void> $loadNewUser(int userId, RemoteAPI api) async {
    // remote 에서 데이터를 채우는 작업
  }
}

mixin _User {
  VibeFutureOr<void> $loadNewUser(int userId, RemoteAPI api);
}

class $UserKey extends Equatable {
  const $UserKey(this.userId);

  final int userId;

  @override
  List<Object?> get props => [userId];
}

extension CreateUserKey on User {
  $UserKey key() => $UserKey(userId);
}

class $User with EquatableMixin, Viber<$User> implements User {
  $User(this.container);
  static $User findUserNew(VibeContainer container, int userId) {
    final key = $UserKey(userId);
    return container.find<$User>(key) ??
        container.add<$User>(key, () {
          final ret = $User(container);
          final src = ret.src = User(userId);
          final api = RemoteAPI(); // 원래는 $RemoteAPI.find(container);
          final result = src.$loadNewUser(userId, api);
          if (result is Future) {
            result.then((_) {
              ret.notify();
            });
          } else {
            ret.notify();
          }
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
  List<Object?> get props => [userId];

  @override
  VibeFutureOr<void> $loadNewUser(int userId, RemoteAPI api) =>
      src.$loadNewUser(userId, api);

  @override
  int get userId => src.userId;

  @override
  int get count => src.count;
  @override
  set count(val) {
    src.count = val;
    notify();
  }
}

@Vibe(lazy: [User.new])
class Usecase with _Usecase {
  Usecase();
  User loadUser(int userId) => userNew(userId);
}

mixin _Usecase {
  late final User Function(int userId) userNew;
}

class $Usecase with EquatableMixin, Viber<$Usecase> implements Usecase {
  $Usecase(this.container);

  static $Usecase find(VibeContainer container) {
    return (container.find<$Usecase>(Usecase) ??
        container.add<$Usecase>(Usecase, () {
          final ret = $Usecase(container);
          ret.src.userNew =
              (int userId) => $User.findUserNew(container, userId);
          ret.notify();
          return ret;
        }()));
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => Usecase;

  @override
  List<Object?> get props => [];

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
