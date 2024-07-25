import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

import 'counter_example.dart';
import 'injection_example.dart';

part 'widget_example.vibe.dart';

@WithVibe([Counter, Derived])
class WidgetExample extends VibeWidget with _WidgetExample {
  const WidgetExample({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Text('${counter.count}'),
          TextButton(
            child: const Text('increase'),
            onPressed: () {
              counter.increase();
            },
          ),
        ],
      );
}

class StatefulExample extends VibeStatefulWidget {
  const StatefulExample({super.key});

  @override
  VibeWidgetState<VibeStatefulWidget> createState() => StatefulExampleState();
}

@WithVibe([Counter, Derived])
class StatefulExampleState extends VibeWidgetState<StatefulExample>
    with _StatefulExampleState {
  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Text('${counter.count}'),
          TextButton(
            onPressed: counter.increase,
            child: const Text('increase'),
          ),
        ],
      );
}
