// ignore_for_file: cascade_invocations
part of 'intifiniy.api.dart';

extension _LoadInfinity on LoadInfinity {
  Counter get counter => $Counter.find($container);
}
