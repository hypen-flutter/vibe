import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

int main() {
  group('ZipStream', () {
    test('immediately emmit when it combines [BehaviorSubject]', () async {
      final subject = BehaviorSubject<int>()..add(0);
      final cb = expectAsync1((_) {}, count: 1);
      ZipStream([subject.stream], (v) => v[0]).listen(cb);
    });
  });
  return 0;
}
