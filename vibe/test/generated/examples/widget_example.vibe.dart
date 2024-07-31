// ignore_for_file: cascade_invocations
part of 'widget_example.dart';

mixin _WidgetExample on VibeWidget {
  Counter get counter {
    final ret = $Counter.find($container);
    $state.addVibe(ret);
    return ret;
  }
}

mixin _StatefulExampleState on VibeWidgetState<StatefulExample> {
  Counter get counter {
    final ret = $Counter.find($container);
    addVibe(ret);
    return ret;
  }

  Computable computableById(int id) {
    final key = ComputableById.getKey(id);
    final ret = $container.find(key);
    if (ret != null) {
      addVibe(ret);
      return ret;
    }
    ComputableById($container)(id).then((v) {
      addVibe(v as Viber);
      rebuild();
    });
    throw const LoadingVibeException();
  }
}

mixin _WidgetWithComputed on VibeWidget {
  Computable computableById(int id) {
    final key = ComputableById.getKey(id);
    final ret = $container.find(key);
    if (ret != null) {
      $state.addVibe(ret);
      return ret;
    }
    ComputableById($container)(id).then((v) {
      $state.addVibe(v as Viber);
      $state.rebuild();
    });
    throw const LoadingVibeException();
  }
}
