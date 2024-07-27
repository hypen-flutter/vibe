import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/collection_example.dart';

int main() {
  group('WrappedCollection', () {
    late VibeContainer container;
    late $Collection collection;
    setUp(() async {
      container = VibeContainer();
      collection = $Collection.find(container)..ref();
    });

    tearDown(() {
      container.dispose();
    });

    test('[List] triggers the change', () async {
      final calledOnce = expectAsync1((_) {});
      // listen 할 때 기존 데이터로 1번 들어옴.
      collection.stream.skip(1).listen(calledOnce);
      collection.list.add(10);
      await Future.delayed(const Duration(milliseconds: 10));
      expect(collection.list.first, equals(10));
    });
    test('[Map] triggers the change', () async {
      final calledOnce = expectAsync1((_) {});
      // listen 할 때 기존 데이터로 1번 들어옴.
      collection.stream.skip(1).listen(calledOnce);
      collection.map[10] = 10;
      await Future.delayed(const Duration(milliseconds: 10));
      expect(collection.map[10], equals(10));
    });
    test('[Set] triggers the change', () async {
      final calledOnce = expectAsync1((_) {});
      // listen 할 때 기존 데이터로 1번 들어옴.
      collection.stream.skip(1).listen(calledOnce);
      collection.set.add(10);
      await Future.delayed(const Duration(milliseconds: 10));
      expect(collection.set.first, equals(10));
    });
  });
  return 0;
}
