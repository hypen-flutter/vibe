// ignore_for_file: cascade_invocations
part of 'widget_example.dart';

mixin _WidgetExample on VibeWidget {
  Counter get counter => $Counter.find($container);

  @override
  List<Viber> get $vibes => [
        counter as Viber,
        if ((this as WidgetExample).suffix is Viber)
          (this as WidgetExample).suffix as Viber
      ];
}

mixin _StatefulExampleState on VibeWidgetState<StatefulExample> {
  Counter get counter => $Counter.find($container);

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

  @override
  List<Viber> get $vibes => [counter as Viber];
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

  @override
  List<Viber> get $vibes => [
        if ((this as WidgetWithComputed).id is Viber)
          (this as WidgetWithComputed).id as Viber
      ];
}
