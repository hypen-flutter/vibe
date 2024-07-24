import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

int main() {
  group('ZipStream', () {
    test('immediately emmit when it combines [BehaviorSubject]', () async {
      final BehaviorSubject<int> subject = BehaviorSubject<int>()..add(0);
      final Func1<void, Object?> cb = expectAsync1((_) {});
      ZipStream(<ValueStream<int>>[subject.stream], (List<int> v) => v[0])
          .listen(cb);
      await subject.close();
    });
  });
  return 0;
}
