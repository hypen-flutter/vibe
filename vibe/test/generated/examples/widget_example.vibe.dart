// ignore_for_file: cascade_invocations
part of 'widget_example.dart';

mixin _WidgetExample on VibeWidget {
  Counter get counter => $Counter.find($container);

  Derived get derived => $Derived.find($container);

  @override
  List<Viber> get $vibes => [counter as Viber, derived as Viber];
}

mixin _StatefulExampleState on VibeWidgetState<StatefulExample> {
  Counter get counter => $Counter.find($container);

  Derived get derived => $Derived.find($container);

  @override
  List<Viber> get $vibes => [counter as Viber, derived as Viber];
}
