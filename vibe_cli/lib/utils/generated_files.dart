import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

extension GetGeneratedFileName on String {
  String get stateFile => '${p.withoutExtension(this)}.vibe.dart';
}

extension ToGeneratedVibeClass on String {
  String get vibeMixin => '_$this';
  String get vibeClass => '\$$this';
}

extension ToGeneratedVibeMethod on String {
  String get selectMethod => '\$select$pascalCase';
  String get streamMethod => '\$stream$pascalCase';
}
