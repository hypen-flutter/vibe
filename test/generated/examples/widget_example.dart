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

  static $Counter? _counter;

  Counter getCounter() {
    if (_counter != null) {
      return _counter!;
    }
    _counter = $Counter.find(_container);
    final stream = _counter!.stream;
    _state.addVibe(stream.listen((_) => _state.markNeedsBuild()));
    return counter;
  }
}
