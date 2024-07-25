import 'dart:async';

import 'package:rxdart/streams.dart';
import 'package:vibe/vibe.dart';

import 'counter_example.dart';

part 'injection_example.vibe.dart';

@Vibe()
class Derived with _Derived {
  @LinkVibe()
  late Counter counter;

  @SelectVibe([Counter])
  late int count;

  @StreamVibe([Counter])
  late int streamedCount;

  @override
  Future<int> $selectCount(Counter counter) async => counter.count;

  @override
  Stream<int> $streamStreamedCount(Stream<Counter> counter) =>
      counter.map((Counter c) => c.count).distinct().where((int c) => c.isEven);
}
