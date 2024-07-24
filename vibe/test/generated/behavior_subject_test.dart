import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';

int main() {
  group('BehaviourSubject', () {
    test('calls listener immediately but asynchronously', () async {
      final BehaviorSubject<int> subject = BehaviorSubject<int>()..add(0);
      bool called = false;
      subject.listen((_) => called = true);
      await Future(() {});
      expect(called, isTrue);
      await subject.close();
    });
  });
  return 0;
}
