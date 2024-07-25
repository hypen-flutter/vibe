import 'package:path/path.dart' as p;

extension GetGeneratedFileName on String {
  String get stateFile => '${p.withoutExtension(this)}.vibe.dart';
}
