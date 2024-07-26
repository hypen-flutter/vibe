// ignore_for_file: cascade_invocations
part of 'widget_example.dart';

mixin _WidgetExample on VibeWidget {
  Counter get counter => $Counter.find($container);

  @override
  List<Viber> get $vibes => [counter as Viber];
}

mixin _StatefulExampleState on VibeWidgetState<StatefulExample> {
  Counter get counter => $Counter.find($container);

  @override
  List<Viber> get $vibes => [counter as Viber];
}