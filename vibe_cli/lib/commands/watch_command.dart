import 'dart:async';

import 'package:args/command_runner.dart';

import '../state/generate_state_command.dart';

class WatchCommand extends Command<void> {
  WatchCommand() {
    addSubcommand(GenerateStateCommand());
  }

  @override
  String get description =>
      'Watch the changes and run code generation continuously.';

  @override
  String get name => 'watch';

  @override
  FutureOr<void> run() async {}
}
