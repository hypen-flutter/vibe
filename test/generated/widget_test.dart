import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'examples/widget_example.dart';

int main() {
  group('VibeWidget example', () {
    testWidgets('can get the dependency', (t) async {
      await t.pumpWidget(const MaterialApp(
        key: ValueKey('0'),
        home: Scaffold(
          body: WidgetExample(),
        ),
      ));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('can rebuild on change', (t) async {
      await t.pumpWidget(const MaterialApp(
        key: ValueKey('1'),
        home: Scaffold(
          body: WidgetExample(),
        ),
      ));
      expect(find.text('0'), findsOneWidget);
      await t.tap(find.text('increase'));
      await t.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });
  });
  return 0;
}
