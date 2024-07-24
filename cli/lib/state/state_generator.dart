import 'package:args/command_runner.dart';

import '../utils/code_analyzer.dart';
import '../utils/project_file.dart';
import '../utils/watcher.dart';

class GenerateStateCommand extends Command<void> {
  @override
  String get description => 'Generate [vibe] state management files';

  @override
  String get name => 'state';
}

class StateWatcher extends Watcher {
  late final Analyzer analyzer = Analyzer(<String>[path]);

  @override
  String get path => './';

  @override
  void onChange(VibeFile file) => forProjectFiles(file, () async {});

  @override
  void onCreate(VibeFile file) => forProjectFiles(file, () async {});

  @override
  void onDelete(VibeFile file) => forProjectFiles(file, () async {});
}
