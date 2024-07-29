import 'package:example/entities/counter/infinity.dart';
import 'package:example/entities/counter/model.dart';
import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

part 'main.vibe.dart';

void main() {
  runApp(
    VibeScope(
      effects: [LoadInfinity()],
      child: const MainApp(),
    ),
  );
}

@WithVibe([Counter, Infinity.fromRemote])
class MainApp extends VibeWidget with _MainApp {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${counter.count}'),
              VibeBuilder(builder: (context) {
                return Text('Infinity Loaded, ${infinityFromRemote()}');
              }),
              TextButton(
                child: const Text('increase'),
                onPressed: () {
                  counter.increase();
                },
              ),
              TextButton(
                child: const Text('decrease'),
                onPressed: () {
                  counter.decrease();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
