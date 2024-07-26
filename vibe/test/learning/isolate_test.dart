import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';

int main() {
  group('Isolate', () {
    late ReceivePort recv;
    SendPort? send;
    late Isolate isolate;
    dynamic returned;

    setUp(() async {
      recv = ReceivePort();
      final stream = recv.asBroadcastStream();
      final waitSender = stream.first.then((sender) => send = sender);
      isolate = await Isolate.spawn(
        (trx) async {
          final ReceivePort rx = ReceivePort();
          trx.send(rx.sendPort);
          await rx.forEach(trx.send);
        },
        recv.sendPort,
      );
      await waitSender;
      stream.listen((m) {
        returned = m;
      });
    });

    tearDown(() {
      recv.close();
      isolate.kill();
    });

    test('returns an object that is different from the passed object',
        () async {
      final testbed = Testbed();
      send!.send(testbed);
      while (returned == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      expect(returned, allOf([isA<Testbed>(), isNot(equals(testbed))]));
    });
  });
  return 0;
}

class Testbed {}
