import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:args/command_runner.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;

import '../type_checker/state_annotations.dart';
import '../type_checker/vibe_class.dart';
import '../utils/code_analyzer.dart';
import '../utils/console.dart';
import '../utils/generated_files.dart';
import '../utils/project_file.dart';
import '../utils/watcher.dart';

class GenerateStateCommand extends Command<void> {
  @override
  String get description => 'Generate [vibe] state management files';

  @override
  String get name => 'state';
}

class StateGenerator extends Watcher {
  late final Analyzer analyzer = Analyzer(<String>[path]);

  @override
  String get path => './';

  final Map<String, Future<void>> _working = <String, Future<void>>{};

  @override
  Future<void> onChange(VibeFile file) =>
      waitPreviousAndRun(file, generateStateFile);

  @override
  Future<void> onCreate(VibeFile file) =>
      waitPreviousAndRun(file, generateStateFile);

  @override
  Future<void> onDelete(VibeFile file) =>
      waitPreviousAndRun(file, deleteGeneratedFile);

  Future<void> waitPreviousAndRun(
          VibeFile file, Future<void> Function(String path) run) =>
      forProjectFiles(file, () async {
        final Set<String> changedFiles =
            await analyzer.applyChanges(file.absolutePath);
        for (final String file in changedFiles) {
          final Future<void> previousWorking =
              _working[file] ?? Future<void>(() {});
          _working[file] = Future<void>(() async {
            await previousWorking;
            await run(file);
          });
        }
      });

  Future<void> deleteGeneratedFile(String path) async {
    await File(path.stateFile).delete();
  }

  Future<void> generateStateFile(String path) async {
    final LibraryElement? element = await analyzer.libraryFor(path);
    if (element == null) {
      return;
    }
    final String partname = p.basename(path.stateFile);
    final bool hasPart = element.parts.any((PartElement e) {
      final DirectiveUri uri = e.uri;
      return (uri as dynamic).relativeUriString.contains(partname);
    });

    if (!hasPart) {
      alert('''
[${p.relative(path)}] must include `part of '$partname';`
''');
      return;
    }

    final List<ClassElement> classes =
        element.topLevelElements.whereType<ClassElement>().toList();

    final String vibers = classes
        .where(vibeAnnotation.hasAnnotationOf)
        .map(generateViberClass)
        .join('\n');

    final String widgetExtensions = classes
        .where((ClassElement e) =>
            vibeWidget.isAssignableFrom(e) ||
            vibeWidgetState.isAssignableFrom(e))
        .map(generateWidgetExtension)
        .join('\n');

    final String basename = p.basename(path);
    await File(path.stateFile).writeAsString(DartFormatter().format('''
part of '$basename';

$vibers

$widgetExtensions
'''));
  }

  Future<String> generateViberClass(ClassElement element) async => '';

  Future<String> generateWidgetExtension(ClassElement element) async => '';
}
