// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:vibe_cli/commands/watch_command.dart';

void main(List<String> arguments) async {
  final CommandRunner<void> runner =
      CommandRunner<void>('vibe', 'A cli for [vibe] framework.')
        ..addCommand(WatchCommand());
  await runner.run(arguments).catchError((dynamic e) {
    if (e is! UsageException) {
      throw e;
    }
    exit(64);
  });
}
