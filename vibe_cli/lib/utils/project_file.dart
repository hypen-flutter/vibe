import 'package:path/path.dart' as p;

import 'watcher.dart';

bool isProjectFile(VibeFile file) {
  final String relativePath = p.relative(file.absolutePath);
  final bool isInProject = relativePath.startsWith('lib/') ||
      relativePath.startsWith('bin/') ||
      relativePath.startsWith('test/');
  final bool isNotGeneratedFile = !relativePath.endsWith('.vibe.dart');
  return isInProject && isNotGeneratedFile;
}

Future<void> forProjectFiles(VibeFile file, void Function() run) async {
  if (!isProjectFile(file)) {
    return;
  }
  run();
}
