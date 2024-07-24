import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

import 'counter_example.dart';

class WidgetExample extends VibeWidget with _WidgetExample {
  const WidgetExample({super.key});

  @LinkVibe()
  Counter get counter => getCounter();

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

mixin _WidgetExample on VibeWidget {
  VibeContainer get _container => VibeStatefulElement.getContainer(this)!;
  VibeWidgetState get _state => VibeStatefulElement.getState(this)!;

  static final Map<dynamic, $Counter> _counter = <dynamic, $Counter>{};

  Counter getCounter() {
    if (_counter[this] != null) {
      return _counter[this]!;
    }
    _counter[this] = $Counter.find(_container);
    _state.addVibe(_counter[this]!, () {
      _counter.remove(this);
    });
    return _counter[this]!;
  }

  @override
  List<Viber Function()> get initializers =>
      <Viber Function()>[() => getCounter() as Viber];
}
