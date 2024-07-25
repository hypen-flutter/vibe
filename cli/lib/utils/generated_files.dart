import 'package:path/path.dart' as p;

extension GetGeneratedFileName on String {
  String get stateFile => '${p.withoutExtension(this)}.vibe.dart';
}

extension ToGeneratedVibeClass on String {
  String get vibeMixin => '_$this';
  String get vibeClass => '\$$this';
}
