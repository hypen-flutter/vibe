import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/computed_example.dart';
import 'examples/widget_example.dart';

int main() {
  group('Widget with Computed Vibe', () {
    testWidgets('can load computed vibe', (t) async {
      await t.runAsync(() async {
        await t.pumpWidget(
          VibeScope(
            effects: [
              MyComputableLoader(),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetWithComputed(
                  id: 1,
                ),
              ),
            ),
          ),
        );
        // await Future.delayed(const Duration(milliseconds: 100));
        await t.pumpAndSettle();
        expect(find.text('1'), findsOne);
      });
    });
    testWidgets('can load different computed vibe', (t) async {
      await t.runAsync(() async {
        await t.pumpWidget(
          VibeScope(
            effects: [
              MyComputableLoader(),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetWithComputed(
                  id: 2,
                ),
              ),
            ),
          ),
        );
        // await Future.delayed(const Duration(milliseconds: 100));
        await t.pumpAndSettle();
        expect(find.text('2'), findsOne);
      });
    });
  });
  return 0;
}
