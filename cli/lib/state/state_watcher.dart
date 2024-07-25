import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;

import '../type_checker/state_annotations.dart';
import '../type_checker/widget_classes.dart';
import '../utils/code_analyzer.dart';
import '../utils/console.dart';
import '../utils/generated_files.dart';
import '../utils/path.dart';
import '../utils/project_file.dart';
import '../utils/watcher.dart';

class StateWatcher extends Watcher {
  late final Analyzer analyzer = Analyzer(
      <String>['lib'.absolutePath, 'bin'.absolutePath, 'test'.absolutePath]);

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
    element.context.declaredVariables.variableNames.forEach(print);

    final List<ClassElement> classes =
        element.topLevelElements.whereType<ClassElement>().toList();

    final List<Future<String>> vibers = classes
        .where((ClassElement e) => vibeAnnotation.hasAnnotationOf(e))
        .map(generateViberClass)
        .toList();

    final List<Future<String>> widgetExtensions = classes
        .where((ClassElement e) =>
            vibeWidget.isAssignableFrom(e) ||
            vibeWidgetState.isAssignableFrom(e))
        .map(generateWidgetExtension)
        .toList();

    if (vibers.isNotEmpty || widgetExtensions.isNotEmpty) {
      info('Investgating $path');
    } else {
      return;
    }

    final String basename = p.basename(path);

    final String code =
        (await Future.wait(<Future<String>>[...vibers, ...widgetExtensions]))
            .where((String e) => e.isNotEmpty)
            .join('\n');

    final bool hasPart = code.isEmpty ||
        element.parts.any((PartElement e) {
          final DirectiveUri uri = e.uri;
          return (uri as dynamic).relativeUriString.contains(partname);
        });

    if (!hasPart) {
      alert('''
[${p.relative(path)}] must include `part of '$partname';`
''');
      return;
    }

    if (code.isEmpty) {
      info('''
Does not need generation.
''');
      return;
    }

    try {
      await File(path.stateFile).writeAsString(DartFormatter().format('''
// ignore_for_file: cascade_invocations
part of '$basename';

$code
'''));
      info('Generated [$partname]');
    } on Exception catch (e, stack) {
      alert(e.toString());
      alert(stack.toString());
    }
  }

  Future<String> generateViberClass(ClassElement element) async {
    final List<FieldElement> fields = element.fields.toList();
    final List<FieldElement> vibeFields = fields
        .where((FieldElement e) => !notVibeAnnotation.hasAnnotationOf(e))
        .toList();
    final List<MethodElement> methods = element.methods.toList();
    final String name = element.displayName;
    final String vibeClassName = name.vibeClass;

    final String mixin = '''
mixin ${name.vibeMixin} {
  void dispose() {}
}
''';

    final String equatableProps =
        vibeFields.map((FieldElement e) => e.name).join(', ');

    final String fielsdRedirection = fields.map((FieldElement e) {
      final String type = e.type.toString();
      final String name = e.name;
      return '''
@override
$type get $name => src.$name;

@override
set $name($type val) {
  src.$name = val;
  notify();
}
''';
    }).join('\n');

    final Set<String> generatedMethods = <String>{'dispose'};

    final String methodsRedirection = methods
        .where((MethodElement m) => !generatedMethods.contains(m.name))
        .map((MethodElement m) {
      final String name = m.name;
      final Iterable<ParameterElement> positionals =
          m.parameters.where((ParameterElement p) => p.isPositional);
      final Iterable<ParameterElement> named =
          m.parameters.where((ParameterElement p) => p.isNamed);
      final String positionalRedirection =
          positionals.map((ParameterElement p) => p.name).join(',');
      final String namedRedirection =
          named.map((ParameterElement p) => '${p.name}: ${p.name}').join(',');
      final String argsRedirections = <String>[
        positionalRedirection,
        namedRedirection
      ].where((String s) => s.isNotEmpty).join(',');

      final DartType returnType = m.returnType;
      final bool isFutureFunction = m.isAsynchronous;
      final bool isFutureOrFunction = returnType.isDartAsyncFutureOr;

      final String redirection = returnType is VoidType
          ? 'src.$name($argsRedirections);'
          : 'final $returnType ret = src.$name($argsRedirections);';

      final String returning = returnType is VoidType ? '' : 'return ret;';

      final String notify = isFutureFunction
          ? '''
ret.then((_) => notify());
'''
          : isFutureOrFunction
              ? '''
if (ret is Future) {
  ret.then((_) => notify());
} else {
  notify();
}
'''
              : '''
notify();
''';

      return '''
@override
$m {
  $redirection
  $notify
  $returning
} 
''';
    }).join('\n');

    final String viber = '''
class $vibeClassName with VibeEquatableMixin, Viber<$vibeClassName> implements $name {
  $vibeClassName(this.container);

  factory $vibeClassName.find(VibeContainer container) {
    $vibeClassName? ret = container.find<$vibeClassName>($name);
    if (ret != null) {
      return ret;
    }
    ret = $vibeClassName(container)..notify();
    container.add<$vibeClassName>($name, ret);
    return ret;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => true;

  @override
  dynamic get key => $name;

  $name src = $name();

  @override
  List<Object?> get props => <Object?>[$equatableProps];

  $fielsdRedirection

  $methodsRedirection

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}
''';
    return '''
$mixin

$viber
''';
  }

  Future<String> generateWidgetExtension(ClassElement element) async => '';
}
