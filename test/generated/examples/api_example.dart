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

  @override
  VibeFutureOr<void> $load(int userId, RemoteAPI api) async {
    // remote 에서 데이터를 채우는 작업
  }
}

mixin _User {
  VibeFutureOr<void> $load(int userId, RemoteAPI api);
}

@Vibe()
class Usecase {
  Usecase();
  @LinkVibe()
  late final User user;
}

class $User with EquatableMixin, Viber<$User> implements User {
  $User(this.container);
  static $User find(VibeContainer container, User user) {
    return (container.find<$User>(User) ??
        container.add<$User>(User, () {
          final ret = $User(container);
          final src = ret.src = user;
          final api = RemoteAPI(); // 원래는 $RemoteAPI.find(container);
          final result = src.$load(user.userId, api);
          if (result is Future) {
            result.then((_) {
              ret.notify();
            });
          } else {
            ret.notify();
          }
          return ret;
        }()));
  }

  @override
  final VibeContainer container;
  @override
  bool get autoDispose => true;

  late User src;
  @override
  List<Object?> get props => [userId];

  @override
  VibeFutureOr<void> $load(int userId, RemoteAPI api) => src.$load(userId, api);

  @override
  int get userId => src.userId;
}
