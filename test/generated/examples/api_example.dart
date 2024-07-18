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

class Usecase {
  late final User user;
}

class $User with EquatableMixin, Viber<$User> implements User {
  $User(this.container);
  static $User find(VibeContainer container, int userId) {
    return (container.find<$User>(User) ??
        container.add<$User>(User, () {
          final ret = $User(container);
          ret.notify();
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
