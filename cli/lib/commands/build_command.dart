import 'package:args/command_runner.dart';

class BuildCommand extends Command<void> {
  BuildCommand();

  @override
  String get description => 'One-time code generation.';

  @override
  String get name => 'build';
}
