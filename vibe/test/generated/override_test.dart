import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe/vibe.dart';

import 'examples/counter_example.dart';
import 'examples/widget_example.dart';

int main() {
  group('[VibeScope]', () {
    testWidgets('referes to the parent container', (t) async {
      await t.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              WidgetExample(),
              VibeScope(
                child: WidgetExample(),
              ),
            ],
          ),
        ),
      ));
      await t.tap(find.text('increase').first);
      await t.pumpAndSettle();
      final text = find.text('1');
      expect(text, findsExactly(2));
    });

    testWidgets('overrides the same type of [Vibe]', (t) async {
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const WidgetExample(),
              VibeScope(
                overrides: [Counter().toVibe()],
                child: const WidgetExample(),
              ),
            ],
          ),
        ),
      ));
      await t.tap(find.text('increase').first);
      await t.pumpAndSettle();
      final text = find.text('1');
      expect(text, findsOne);
    });

    testWidgets('behaves as it is', (t) async {
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const WidgetExample(),
              VibeScope(
                overrides: [Counter().toVibe()],
                child: const WidgetExample(),
              ),
            ],
          ),
        ),
      ));
      await t.tap(find.text('increase').first);
      await t.tap(find.text('increase').last);
      await t.pumpAndSettle();
      final text = find.text('1');
      expect(text, findsExactly(2));
    });

    testWidgets('ignores the parent scope', (t) async {
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const WidgetExample(),
              VibeScope(
                overrides: [Counter().toVibe()],
                child: const WidgetExample(),
              ),
            ],
          ),
        ),
      ));
      await t.tap(find.text('increase').last);
      await t.pumpAndSettle();
      final text = find.text('1');
      expect(text, findsExactly(1));
    });
  });
  return 0;
}
