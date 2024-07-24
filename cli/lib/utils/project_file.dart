import 'package:path/path.dart' as p;

import 'watcher.dart';

bool isProjectFile(VibeFile file) {
  final String relativePath = p.relative(file.absolutePath);
  return relativePath.startsWith('lib/') ||
      relativePath.startsWith('bin/') ||
      relativePath.startsWith('test/');
}

void forProjectFiles(VibeFile file, void Function() run) {
  if (!isProjectFile(file)) {
    return;
  }
  run();
}
