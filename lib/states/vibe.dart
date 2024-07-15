part of 'states.dart';

typedef VibeFutureOr<T> = FutureOr<T>;

mixin Viber<T> on EquatableMixin {
  final subject = BehaviorSubject<List>();
  late final stream = subject.distinct(deepEquals).map<T>((event) => this as T);

  void notify() {
    subject.add(props);
  }
}
