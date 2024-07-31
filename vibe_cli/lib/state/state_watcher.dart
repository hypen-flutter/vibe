import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../type_checker/state_annotations.dart';
import '../type_checker/state_classes.dart';
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
    if (File(path.stateFile).existsSync()) {
      await File(path.stateFile).delete();
    }
  }

  Future<void> generateStateFile(String path) async {
    final LibraryElement? element = await analyzer.libraryFor(path);
    if (element == null) {
      return;
    }
    final String partname = p.basename(path.stateFile);

    final List<ClassElement> classes =
        element.topLevelElements.whereType<ClassElement>().toList();

    try {
      final List<Future<String>> vibers = classes
          .where((ClassElement e) => vibeAnnotation.hasAnnotationOf(e))
          .map(generateViberClass)
          .toList();

      final List<Future<String>> widgetExtensions = classes
          .where((ClassElement e) =>
              vibeWidget.isAssignableFrom(e) ||
              vibeWidgetState.isAssignableFrom(e))
          .where(withVibeAnnotation.hasAnnotationOf)
          .map(generateWidgetExtension)
          .toList();

      final List<Future<String>> effectExtensions = classes
          .where(vibeEffectAnnotation.isAssignableFrom)
          .where(withVibeAnnotation.hasAnnotationOf)
          .map(generateEffectExtension)
          .toList();

      if (vibers.isNotEmpty ||
          widgetExtensions.isNotEmpty ||
          effectExtensions.isNotEmpty) {
        info('Investgating $path');
      } else {
        return;
      }

      final String basename = p.basename(path);

      final String code = (await Future.wait(<Future<String>>[
        ...vibers,
        ...widgetExtensions,
        ...effectExtensions
      ]))
          .where((String e) => e.isNotEmpty)
          .join('\n');

      final bool hasPart = code.isEmpty ||
          element.parts.any((PartElement e) {
            final DirectiveUri uri = e.uri;
            return (uri as dynamic).relativeUriString.contains(partname);
          });
      if (!hasPart) {
        alert('''
[${p.relative(path)}] must include `part '$partname';`
''');
        return;
      }

      if (code.isEmpty) {
        info('''
Does not need generation.
''');
        return;
      }
      await File(path.stateFile).writeAsString(DartFormatter().format('''
// ignore_for_file: cascade_invocations
part of '$basename';

$code
'''));
      info('Generated [$partname]');
    } on Exception catch (e) {
      alert(e.toString());
    }
  }

  Future<String> generateViberClass(ClassElement element) async {
    final List<FieldElement> fields = element.fields.toList();
    final List<FieldElement> vibeFields = fields
        .where((FieldElement e) => !notVibeAnnotation.hasAnnotationOf(e))
        .toList();
    final List<FieldElement> selectionFields = fields
        .where((FieldElement e) => selectVibeAnnotation.hasAnnotationOf(e))
        .toList();
    final List<FieldElement> streamFields = fields
        .where((FieldElement e) => streamVibeAnnotation.hasAnnotationOf(e))
        .toList();
    final List<FieldElement> linkedFields = fields
        .where((FieldElement e) => linkVibeAnnotation.hasAnnotationOf(e))
        .toList();
    final String className = element.displayName;
    final String vibeClassName = className.vibeClass;

    final Set<String> generatedMethods = <String>{};
    for (final FieldElement f in selectionFields) {
      generatedMethods.add(f.name.selectMethod);
    }

    for (final FieldElement f in streamFields) {
      generatedMethods.add(f.name.streamMethod);
    }

    final String mixin = '''
mixin ${className.vibeMixin} implements GeneratedViber<$vibeClassName> {
  @override
  dynamic \$key = $className;

  @override
  dynamic get \$effectKey => $className;

  void dispose() {}
  ${_generateSelectVibeMethods(selectionFields)}
  ${_generateStreamVibeMethods(streamFields)}
  @override
  $vibeClassName Function(VibeContainer container, {bool override}) toVibe() =>
      (VibeContainer container, {bool override = false}) 
        => $vibeClassName.find(container, src: this as $className, overrides: override);
}
''';
    final String constructorBody = (linkedFields.isEmpty &&
            selectionFields.isEmpty &&
            streamFields.isEmpty)
        ? '''
ret!.notify();
'''
        : _generateConstructorBody(
            element: element,
            linkedFields: linkedFields,
            selectionFields: selectionFields,
            streamFields: streamFields);

    final bool autoDispose = vibeAnnotation
        .firstAnnotationOf(element)!
        .getField('autoDispose')!
        .toBoolValue()!;

    final String assignComputed = element.fields
        .where((FieldElement f) => linkComputedAnnotation.hasAnnotationOf(f))
        .map((FieldElement f) {
      final String name = f.name;
      final String type = f.type.getDisplayString().replaceAll('*', '');
      return '''
$name = $type(container, parent: ret!)
''';
    }).join('..');

    final String viber = '''
class $vibeClassName with VibeEquatableMixin, Viber<$vibeClassName> implements $className {
  $vibeClassName(this.container);

  factory $vibeClassName.find(VibeContainer container, {$className? src, bool overrides = false}) {
    src ??= $className();
    $vibeClassName? ret = container.find<$vibeClassName>(src.\$key);
    if (ret != null && !overrides) {
      return ret;
    }
    ret = $vibeClassName(container)..src = src;
    ${assignComputed.isNotEmpty ? 'src..$assignComputed;' : ''}
    $constructorBody
    container.add<$vibeClassName>(src.\$key, ret, overrides: overrides);
    return ret!;
  }

  @override
  final VibeContainer container;

  @override
  bool get autoDispose => $autoDispose;

  @override
  dynamic get \$effectKey => src.\$effectKey;

  @override
  late dynamic \$key = src.\$key;

  List<${className}Effect> get effects 
        => (container.findEffects(\$effectKey) ?? [])
            .map((e) => e as ${className}Effect)
            .toList();

  late $className src;

  @override
  List<Object?> get props => <Object?>[${_generateEquatableProps(vibeFields)}];

  ${_generateFieldsRedirection(fields)}

  ${_generateMethodsRedirection(element, generatedMethods)}

  @override
  $vibeClassName Function(VibeContainer container, {bool override}) toVibe() =>
    src.toVibe();

  @override
  void dispose() {
    src.dispose();
    super.dispose();
  }
}
''';

    final String effect = _generateEffect(element, <String>{
      ...generatedMethods,
      'dispose',
    });
    final String computedVibe = _generateComputed(element);

    return '''
$mixin

$viber

$effect

$computedVibe
''';
  }

  String _generateComputed(ClassElement element) {
    final String className = element.name;
    final List<ConstructorElement> constructors = element.constructors
        .where((ConstructorElement c) => computedAnnotation.hasAnnotationOf(c))
        .toList();
    if (constructors.isEmpty) {
      return '';
    }

    return constructors.map((ConstructorElement c) {
      final String name = c.name.pascalCase;
      final String keyName = '_$className${name}Key';
      final String computeName = 'Compute$className$name';
      final String computedName = '$className$name';
      final List<ParameterElement> params = c.parameters;
      final List<ParameterElement> positionals =
          params.where((ParameterElement p) => p.isPositional).toList();
      final List<ParameterElement> named =
          params.where((ParameterElement p) => p.isNamed).toList();
      final String thisPositionals =
          positionals.map((ParameterElement p) => 'this.${p.name}').join(',');

      final String thisNamed = named.isNotEmpty
          ? '{${named.map((ParameterElement p) => 'this.${p.name}').join(',')}}'
          : '';

      final String thisParams = <String>[thisPositionals, thisNamed]
          .where((String s) => s.isNotEmpty)
          .join(',');
      final String fields = params.map((ParameterElement p) {
        final String name = p.name;
        final String override =
            element.fields.where((FieldElement f) => f.name == name).isNotEmpty
                ? '@override'
                : '';
        final String finalState = override.isEmpty
            ? 'final'
            : element.fields
                    .where((FieldElement f) => f.name == name)
                    .first
                    .isFinal
                ? 'final'
                : '';
        return '''
$override
$finalState ${p.type} $name;
''';
      }).join('\n');

      final String redirectPositionals =
          positionals.map((ParameterElement p) => p.name).join(',');
      final String redirectNamed = named.isNotEmpty
          ? '{${named.map(
                (ParameterElement p) => '${p.name}: ${p.name}',
              ).join(',')}}'
          : '';

      final String redirectParams = <String>[redirectPositionals, redirectNamed]
          .where((String s) => s.isNotEmpty)
          .join(',');

      final String props = params.map((ParameterElement p) => p.name).join(',');
      final String privateKey = '''
class $keyName with VibeEquatableMixin {
  $keyName($thisParams);
  $fields

  @override
  List<Object?> get props => [$props];
}
''';
      final String originalPositionals = positionals
          .map((ParameterElement p) => '${p.type} ${p.name}')
          .join(',');
      final String originalNamed = named.isNotEmpty
          ? '{${named.map(
                (ParameterElement p) => '${p.type} ${p.name}',
              ).join(',')}}'
          : '';
      final String originalParams = <String>[originalPositionals, originalNamed]
          .where((String s) => s.isNotEmpty)
          .join(',');
      final String computer = '''
mixin $computeName on VibeEffect {
  @override
  void init() {
    addKey($computeName);
  }

  Future<$className> compute$computedName($originalParams);
}
''';
      final String computed = '''
class $computedName extends Computed {
  $computedName(this.container, {this.parent, this.callback});

  final VibeContainer container;
  final Viber? parent;
  final void Function(Viber v)? callback;

  static dynamic getKey($originalParams) => $keyName($redirectParams);
  static final Map<dynamic, Future> loading = {};

  Future<$className> call($originalParams) async {
    final loader = (container.findEffects($computeName) ?? [])
        .whereType<$computeName>()
        .firstOrNull;
    if (loader == null) {
      throw Exception('You did not register [$computeName].');
    }

    final key = getKey($redirectParams);
    final prev = container.find(key);
    if (prev != null) {
      parent?.addDependency(prev);
      await prev.stream.first;
      callback?.call(prev as Viber);
      return prev as $className;
    }

    final futureSrc = 
      loading[key] ??= loader.compute$computedName($redirectParams);
    loading[key] = futureSrc;
    final src = await futureSrc;
    src.\$key = key;

    final ret = ${className.vibeClass}.find(container, src: src);
    parent?.addDependency(ret);

    loading.remove(key);

    await ret.stream.first;
    callback?.call(ret);
    return ret;
  }
}
''';
      return '''
$privateKey
$computer
$computed
''';
    }).join('\n');
  }

  String _generateEffect(ClassElement element, Set<String> except) {
    final String className = element.name;
    final List<MethodElement> methods = element.methods.toList();
    final String methodEffects = methods
        .where((MethodElement e) => !except.contains(e.name))
        .map((MethodElement m) {
      final String name = m.name;
      final String decl = m.toString();
      final String params = decl.substring(decl.indexOf(name) + name.length);
      return '''
Future<void> did$className${name.pascalCase}$params async {}
''';
    }).join('\n');
    return '''
mixin ${className}Effect on VibeEffect {
  @override
  void init() {
    addKey($className);
  }
  Future<void> did${className}Updated() async {}
  $methodEffects
}
''';
  }

  String _generateStreamVibeMethods(List<FieldElement> streamFields) =>
      streamFields.map((FieldElement f) {
        final String type = f.type.toString();
        final String dependencies =
            streamVibeAnnotation.annotationsOf(f).map((DartObject e) {
          final List<DartObject>? list = e.getField('sources')?.toListValue();
          if (list?.isEmpty ?? true) {
            throw Exception('[StreamVibe] must be provided [sources].');
          }
          return list!.map((DartObject e) {
            final DartType? type = e.toTypeValue();
            if (type == null ||
                !vibeAnnotation.hasAnnotationOf(type.element!)) {
              throw Exception(
                  '[StreamVibe.sources] must contains [@Vibe] type only.');
            }
            final String typeName = type.toString();
            return 'Stream<$typeName> ${typeName.camelCase}';
          }).join(',');
        }).join(',');
        return '''
Stream<$type> ${f.name.streamMethod}($dependencies);
''';
      }).join('\n');

  String _generateSelectVibeMethods(List<FieldElement> selectionFields) =>
      selectionFields.map((FieldElement f) {
        final String type = f.type.toString();
        final String dependencies =
            selectVibeAnnotation.annotationsOf(f).map((DartObject e) {
          final List<DartObject>? list = e.getField('sources')?.toListValue();
          if (list?.isEmpty ?? true) {
            throw Exception('[SelectVibe] must be provided [sources].');
          }
          return list!.map((DartObject e) {
            final DartType? type = e.toTypeValue();
            if (type == null ||
                !vibeAnnotation.hasAnnotationOf(type.element!)) {
              throw Exception(
                  '[SelectVibe.sources] must contains [@Vibe] type only.');
            }
            final String typeName = type.toString();
            return '$typeName ${typeName.camelCase}';
          }).join(',');
        }).join(',');
        return '''
VibeFutureOr<$type> ${f.name.selectMethod}($dependencies);
''';
      }).join('\n');

  String _generateEquatableProps(List<FieldElement> elements) =>
      elements.map((FieldElement e) => e.name).join(', ');

  String _generateFieldsRedirection(List<FieldElement> fields) =>
      fields.map((FieldElement e) {
        final String type = e.type.getDisplayString().replaceAll('*', '');
        final String name = e.name;
        final bool isSetter = e.setter != null;
        String? wrappedType;
        if (e.type.isDartCoreList) {
          wrappedType = 'Vibe$type';
        } else if (e.type.isDartCoreSet) {
          wrappedType = 'Vibe$type';
        } else if (e.type.isDartCoreMap) {
          wrappedType = 'Vibe$type';
        }
        if (wrappedType != null) {
          return '''
late $wrappedType _$name = $wrappedType(src.$name, () => notify(force: true));
@override
$type get $name => _$name;

${isSetter ? '''
@override
set $name($type val) {
  src.$name = val;
  _$name = $wrappedType(val, notify);
  notify();
}
''' : ''}
''';
        }
        return '''
@override
$type get $name => src.$name;

${isSetter ? '''
@override
set $name($type val) {
  src.$name = val;
  notify();
}
''' : ''}

''';
      }).join('\n');

  String _generateMethodsRedirection(
          ClassElement element, Set<String> generatedMethods) =>
      element.methods
          .toList()
          .where((MethodElement m) => m.name != 'dispose')
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

        String notify = isFutureFunction
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
        String effect = '''
Future(() {
  for(final effect in effects) {
    Future(() {
      effect.did${element.name}${name.pascalCase}($argsRedirections);
    });
  }
});
''';
        if (generatedMethods.contains(name)) {
          notify = '';
          effect = '';
        }

        final String ret = '''
  @override
  $m {
    $redirection
    $notify
    $effect
    $returning
  } 
  ''';
        return ret;
      }).join('\n');

  String _generateConstructorBody({
    required ClassElement element,
    required List<FieldElement> linkedFields,
    required List<FieldElement> selectionFields,
    required List<FieldElement> streamFields,
  }) {
    final Set<String> dependencies = <String>{};

    for (final FieldElement f in linkedFields) {
      String typename = f.type.toString();
      if (!vibeAnnotation.hasAnnotationOf(f.type.element!)) {
        throw Exception(
            'You can not inject non-[@Vibe()] [$typename] on [LinkVibe]');
      }
      if (typename.endsWith('?')) {
        typename = typename.substring(0, typename.length - 1);
      }
      dependencies.add(typename);
    }

    for (final FieldElement f in selectionFields) {
      final DartObject annotation = selectVibeAnnotation.firstAnnotationOf(f)!;
      annotation
          .getField('sources')!
          .toListValue()!
          .map((DartObject o) => o.toTypeValue())
          .map((DartType? t) => t.toString())
          .forEach(dependencies.add);
    }

    for (final FieldElement f in streamFields) {
      final DartObject annotation = streamVibeAnnotation.firstAnnotationOf(f)!;
      annotation
          .getField('sources')!
          .toListValue()!
          .map((DartObject o) => o.toTypeValue())
          .map((DartType? t) => t.toString())
          .forEach(dependencies.add);
    }

    final String loadDependencies = dependencies.map((String d) => '''
final ${d.vibeClass} ${d.camelCase} = ${d.vibeClass}.find(container);
''').join('\n');

    final String addDependencies = '${dependencies.map((String name) => '''
addDependency(${name.camelCase})
''').toList().join('..')};';

    final String assignLinks = linkedFields.map((FieldElement f) {
      final String name = f.name;
      String typename = f.type.toString();
      if (typename.endsWith('?')) {
        typename = typename.substring(0, typename.length - 1);
      }
      final String loadedName = typename.camelCase;
      return '''
ret!.src.$name = $loadedName;
ret!.addSubscription(
  $loadedName.stream.skip(1).listen(
    (\$$typename $name) => ret!.$name = $name
  )
);
''';
    }).join('\n');

    final String linkedStreams = linkedFields.map((FieldElement f) {
      final String name = f.name;
      return '''
$name.stream
''';
    }).join(',');

    final String assignSelection = selectionFields.map((FieldElement f) {
      final String name = f.name;
      final DartObject annotation = selectVibeAnnotation.firstAnnotationOf(f)!;
      final List<String> dependencies = annotation
          .getField('sources')!
          .toListValue()!
          .map((DartObject o) => o.toTypeValue())
          .map((DartType? t) => t.toString())
          .map((String name) => name.camelCase)
          .toList();

      return '''
ret!.src.$name = await ret!.${name.selectMethod}(${dependencies.join(',')});
ret!.addSubscription(
  ZipStream([${dependencies.map((String d) => '$d.stream')}], (_) => _).skip(1)
    .asyncMap((_) => ret!.${name.selectMethod}(${dependencies.join(',')}))
    .distinct()
    .listen((e) => ret!.$name = e)
);
''';
    }).join('\n');

    final String assignStreamed = streamFields.map((FieldElement f) {
      final String name = f.name;
      final DartObject annotation = streamVibeAnnotation.firstAnnotationOf(f)!;
      final String dependencies = annotation
          .getField('sources')!
          .toListValue()!
          .map((DartObject o) => o.toTypeValue())
          .map((DartType? t) => t.toString())
          .map((String name) => name.camelCase)
          .map((String name) => '$name.stream')
          .join(', ');

      return '''
final streamed${name.pascalCase} = ret!.${name.streamMethod}($dependencies);
ret!.src.$name = await streamed${name.pascalCase}.first;
ret!.addSubscription(
  streamed${name.pascalCase}.skip(1).listen(
    (e) => ret!.$name = e
  )
);
''';
    }).join('\n');

    final String zipStream = '''
ZipStream(<Stream<dynamic>>[$linkedStreams], (List<dynamic> zs) => zs)
  .first
  .then(
    (List<dynamic> _) async {
      $assignLinks
      $assignSelection
      $assignStreamed

      ret!.notify();
    }
  );
''';

    return '''
$loadDependencies
ret..
$addDependencies
$zipStream
''';
  }

  Future<String> generateWidgetExtension(ClassElement element) async {
    final String className = element.name;
    final InterfaceType superType = element.allSupertypes
        .where((InterfaceType s) =>
            s.element.name == 'VibeWidget' ||
            s.element.name == 'VibeWidgetState')
        .first;
    String superTypeName = superType.element.name;
    if (superTypeName == 'VibeWidgetState') {
      superTypeName = 'VibeWidgetState<${superType.typeArguments.first}>';
    }
    final List<DartType> linkedVibes = withVibeAnnotation
        .firstAnnotationOf(element)!
        .getField('vibes')!
        .toListValue()!
        .where((DartObject e) => e.toTypeValue() != null)
        .map((DartObject e) => e.toTypeValue()!)
        .toList();

    final List<ExecutableElement> computed = withVibeAnnotation
        .firstAnnotationOf(element)!
        .getField('vibes')!
        .toListValue()!
        .where((DartObject e) => e.toFunctionValue() != null)
        .map((DartObject e) => e.toFunctionValue()!)
        .where((ExecutableElement e) => computedAnnotation.hasAnnotationOf(e))
        .toList();

    final String vibeGetters = linkedVibes.map((DartType type) {
      final Element element = type.element!;
      final String typename = type.toString();
      if (!vibeAnnotation.hasAnnotationOf(element)) {
        throw Exception(
            'You can not inject non-[@Vibe()] [$typename] on [WithVibe]');
      }
      return '''
$typename get ${typename.camelCase} {
  final ret = ${typename.vibeClass}.find(\$container);
  ${superTypeName == 'VibeWidget' ? r'$state.' : ''}addVibe(ret);
  return ret;
} 
''';
    }).join('\n');

    final String callback =
        superTypeName == 'VibeWidget' ? r'$state.addVibe' : 'addVibe';
    final String rebuild =
        superTypeName == 'VibeWidget' ? r'$state.rebuild()' : 'rebuild()';

    final String computedVibes = computed.map((ExecutableElement e) {
      final String name = e.name;
      final String className = e.enclosingElement.name!;
      final String copmutedName = className + name.pascalCase;
      final List<ParameterElement> positionals =
          e.parameters.where((ParameterElement p) => p.isPositional).toList();
      final List<ParameterElement> named =
          e.parameters.where((ParameterElement p) => p.isNamed).toList();
      final String originalPositionals = positionals
          .map((ParameterElement p) => '${p.type} ${p.name}')
          .join(',');
      final String originalNamed = named.isNotEmpty
          ? '{${named.map(
                (ParameterElement p) => '${p.type} ${p.name}',
              ).join(',')}}'
          : '';
      final String originalParams = <String>[originalPositionals, originalNamed]
          .where((String s) => s.isNotEmpty)
          .join(',');

      final String redirectParams = e.parameters
          .map((ParameterElement p) =>
              p.isNamed ? '${p.name}: ${p.name}' : p.name)
          .join(',');

      return '''
$className ${copmutedName.camelCase}($originalParams) {
    final key = $copmutedName.getKey($redirectParams);
    final ret = \$container.find(key);
    if (ret != null) {
      $callback(ret);
      return ret;
    }
    $copmutedName(\$container)($redirectParams).then((v) {
      $callback(v as Viber);
      $rebuild;
    });
    throw const LoadingVibeException();
}
''';
    }).join('\n');

    return '''
mixin _$className on $superTypeName {
  $vibeGetters
  $computedVibes
}
''';
  }

  Future<String> generateEffectExtension(ClassElement element) async {
    final String className = element.name;
    final List<DartType> linkedVibes = withVibeAnnotation
        .firstAnnotationOf(element)!
        .getField('vibes')!
        .toListValue()!
        .where((DartObject e) => e.toTypeValue() != null)
        .map((DartObject e) => e.toTypeValue()!)
        .toList();

    final List<ExecutableElement> computed = withVibeAnnotation
        .firstAnnotationOf(element)!
        .getField('vibes')!
        .toListValue()!
        .where((DartObject e) => e.toFunctionValue() != null)
        .map((DartObject e) => e.toFunctionValue()!)
        .where((ExecutableElement e) => computedAnnotation.hasAnnotationOf(e))
        .toList();

    final String vibeGetters = linkedVibes.map((DartType type) {
      final Element element = type.element!;
      final String typename = type.toString();
      if (!vibeAnnotation.hasAnnotationOf(element)) {
        throw Exception(
            'You can not inject non-[@Vibe()] [$typename] on [WithVibe]');
      }
      return '''
$typename get ${typename.camelCase} => ${typename.vibeClass}.find(\$container);
''';
    }).join('\n');

    final String computedVibes = computed.map((ExecutableElement e) {
      final String name = e.name;
      final String className = e.enclosingElement.name!;
      final String copmutedName = className + name.pascalCase;
      final List<ParameterElement> positionals =
          e.parameters.where((ParameterElement p) => p.isPositional).toList();
      final List<ParameterElement> named =
          e.parameters.where((ParameterElement p) => p.isNamed).toList();
      final String originalPositionals = positionals
          .map((ParameterElement p) => '${p.type} ${p.name}')
          .join(',');
      final String originalNamed = named.isNotEmpty
          ? '{${named.map(
                (ParameterElement p) => '${p.type} ${p.name}',
              ).join(',')}}'
          : '';
      final String originalParams = <String>[originalPositionals, originalNamed]
          .where((String s) => s.isNotEmpty)
          .join(',');

      final String redirectParams = e.parameters
          .map((ParameterElement p) =>
              p.isNamed ? '${p.name}: ${p.name}' : p.name)
          .join(',');

      return '''
Future<$className> ${copmutedName.camelCase}($originalParams) async {
    final key = $copmutedName.getKey($redirectParams);
    final ret = \$container.find(key);
    if (ret != null) {
      return ret;
    }
    return $copmutedName(\$container)($redirectParams);
}
''';
    }).join('\n');

    return '''
extension _$className on $className {
  $vibeGetters
  $computedVibes
}
''';
  }
}
