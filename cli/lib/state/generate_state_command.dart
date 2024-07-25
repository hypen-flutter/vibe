import 'dart:async';

import 'package:args/command_runner.dart';

import 'state_watcher.dart';

class GenerateStateCommand extends Command<void> {
  GenerateStateCommand({this.watch = true});

  /// Whether watch the changes.
  final bool watch;

  @override
  String get description => 'Generate [vibe] state management files';

  @override
  String get name => 'state';

  final StateWatcher generator = StateWatcher();

  @override
  FutureOr<void>? run() => generator.run();
}
