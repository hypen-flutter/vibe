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
            onCreate(VibeFile(e.path));
          case final FileSystemDeleteEvent e:
            onDelete(VibeFile(e.path));
          case final FileSystemMoveEvent e:
            onDelete(VibeFile(e.path));
            onCreate(VibeFile(e.destination!));
          case final FileSystemModifyEvent e:
            onChange(VibeFile(e.path));
        }
      } on Exception catch (e) {
        alert(e.toString());
      }
    }
  }
}

class VibeFile {
  VibeFile(this.path);
  final String path;
}
