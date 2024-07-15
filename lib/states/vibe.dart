part of 'states.dart';

mixin Viber<T> on EquatableMixin {
  final subject = BehaviorSubject<List>();
  late final stream = subject.distinct(deepEquals).map<T>((event) => this as T);

  void notify() {
    subject.add(props);
  }
}
