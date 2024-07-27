import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/counter_example.dart';
import 'examples/widget_example.dart';

int main() {
  group('[CounterEffect]', () {
    testWidgets('runs exactly once', (t) async {
      final effect = MyEffect(expectAsync0(() {}));
      await t.pumpWidget(
        VibeScope(
          effects: [
            effect,
          ],
          child: const MaterialApp(
            home: WidgetExample(),
          ),
        ),
      );
      await t.runAsync(() async {
        await t.pumpAndSettle();
      });
      await t.tap(find.text('increase'));
      await t.runAsync(() async {
        await t.pumpAndSettle();
      });
    });

    testWidgets('runs multiple effects', (t) async {
      final effect = MyEffect(expectAsync0(() {}, count: 2));
      await t.pumpWidget(
        VibeScope(
          effects: [effect, effect],
          child: const MaterialApp(
            home: WidgetExample(),
          ),
        ),
      );
      await t.runAsync(() async {
        await t.pumpAndSettle();
      });
      await t.tap(find.text('increase'));
      await t.runAsync(() async {
        await t.pumpAndSettle();
      });
    });
  });
  return 0;
}

class MyEffect extends VibeEffect with CounterEffect {
  MyEffect(this.callback);
  final Callback callback;
  @override
  Future<void> didCounterIncrease() async {
    callback();
  }
}
