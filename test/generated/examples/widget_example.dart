import 'package:flutter/material.dart';
import 'package:vibe/annotations/annotations.dart';
import 'package:vibe/states/states.dart';
import 'package:vibe/widgets/widgets.dart';

import 'counter_example.dart';

class WidgetExample extends VibeStatelessWidget {
  const WidgetExample({super.key});

  @LinkVibe()
  Counter get counter => getCounter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
}

extension VibeWidgetExample on WidgetExample {
  VibeContainer get _container => VibeStatefulElement.getContainer(this);
  VibeWidgetState get _state => VibeStatefulElement.getState(this)!;

  static final Map<dynamic, $Counter> _counter = {};

  Counter getCounter() {
    if (_counter[this] != null) {
      return _counter[this]!;
    }
    _counter[this] = $Counter.find(_container);
    _state.addVibe(_counter[this]!, () {
      _counter.remove(this);
    });
    return counter;
  }
}
