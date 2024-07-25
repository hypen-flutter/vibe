import 'dart:io';

import 'package:meta/meta.dart';

import 'console.dart';

abstract class Watcher {
  String get path;
  Future<void> onCreate(VibeFile file) async {}
  Future<void> onDelete(VibeFile file) async {}
  Future<void> onChange(VibeFile file) async {}

  final Map<String, Future<void>> _working = <String, Future<void>>{};

  @nonVirtual
  Future<void> run() async {
    final Stream<FileSystemEvent> events =
        Directory(path).watch(recursive: true);
    await for (final FileSystemEvent event in events) {
      final String path = event.path.absolutePath;
      // wait until the previous work is done
      await (_working[path] ?? Future<void>(() {}));
      try {
        switch (event) {
          case final FileSystemCreateEvent _:
            _working[path] = onCreate(VibeFile(path));
          case final FileSystemDeleteEvent _:
            _working[path] = onDelete(VibeFile(path));
          case final FileSystemMoveEvent e:
            _working[path] = onDelete(VibeFile(path));
            _working[e.destination!.absolutePath] =
                onCreate(VibeFile(e.destination!.absolutePath));
          case final FileSystemModifyEvent _:
            _working[path] = onChange(VibeFile(path));
        }
      } on Exception catch (e) {
        alert(e.toString());
      }
    }
  }
}

class VibeFile {
  VibeFile(this.absolutePath);
  final String absolutePath;
}

extension on String {
  String get absolutePath => File(this).absolute.path;
}
