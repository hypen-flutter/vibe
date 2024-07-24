import 'dart:io';

import 'package:cli/utils/console.dart';
import 'package:meta/meta.dart';

abstract class Watcher {
  String get path;
  void onCreate(VibeFile file) {}
  void onDelete(VibeFile file) {}
  void onChange(VibeFile file) {}

  @nonVirtual
  void run() async {
    final events = Directory(path).watch(recursive: true);
    await for (final event in events) {
      try {
        switch (event) {
          case FileSystemCreateEvent e:
            onCreate(VibeFile(e.path));
          case FileSystemDeleteEvent e:
            onDelete(VibeFile(e.path));
          case FileSystemMoveEvent e:
            onDelete(VibeFile(e.path));
            onCreate(VibeFile(e.destination!));
          case FileSystemModifyEvent e:
            onChange(VibeFile(e.path));
        }
      } catch (e, _) {
        alert(e.toString());
      }
    }
  }
}

class VibeFile {
  VibeFile(this.path);
  final String path;
}
