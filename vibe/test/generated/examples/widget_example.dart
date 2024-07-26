import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

import 'counter_example.dart';

part 'widget_example.vibe.dart';

@WithVibe([
  Counter,
])
class WidgetExample extends VibeWidget with _WidgetExample {
  const WidgetExample({
    this.suffix = '',
    super.key,
  });

  final String suffix;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Text('${counter.count}$suffix'),
          TextButton(
            child: Text('increase$suffix'),
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

@WithVibe([
  Counter,
])
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
