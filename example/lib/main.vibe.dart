// ignore_for_file: cascade_invocations
part of 'main.dart';

mixin _MainApp on VibeWidget {
  Counter get counter => $Counter.find($container);

  @override
  List<Viber> get $vibes => [counter as Viber];
}
