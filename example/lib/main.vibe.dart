// ignore_for_file: cascade_invocations
part of 'main.dart';

mixin _MainApp on VibeWidget {
  Counter get counter {
    final ret = $Counter.find($container);
    $state.addVibe(ret);
    return ret;
  }

  Infinity infinityFromRemote() {
    final key = InfinityFromRemote.getKey();
    final ret = $container.find(key);
    if (ret != null) {
      $state.addVibe(ret);
      return ret;
    }
    InfinityFromRemote($container)().then((v) {
      $state.addVibe(v as Viber);
      $state.rebuild();
    });
    throw const LoadingVibeException();
  }
}
