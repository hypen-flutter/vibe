import 'dart:io';

import 'package:meta/meta.dart';

import 'console.dart';

abstract class Watcher {
  String get path;
  void onCreate(VibeFile file) {}
  void onDelete(VibeFile file) {}
  void onChange(VibeFile file) {}

  @nonVirtual
  Future<void> run() async {
    final Stream<FileSystemEvent> events =
        Directory(path).watch(recursive: true);
    await for (final FileSystemEvent event in events) {
      try {
        switch (event) {
          case final FileSystemCreateEvent e:
            onCreate(VibeFile(e.path.absolutePath));
          case final FileSystemDeleteEvent e:
            onDelete(VibeFile(e.path.absolutePath));
          case final FileSystemMoveEvent e:
            onDelete(VibeFile(e.path.absolutePath));
            onCreate(VibeFile(e.destination!.absolutePath));
          case final FileSystemModifyEvent e:
            onChange(VibeFile(e.path.absolutePath));
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
