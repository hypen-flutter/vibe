import 'dart:io';

import 'package:path/path.dart' as p;

extension ToAbsolutePathl on String {
  String get absolutePath => p.normalize(File(this).absolute.path);
}
