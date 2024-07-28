import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class InjectPartAssist extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addClassDeclaration((node) {
      final element = node.declaredElement;
      if (element == null) {
        return;
      }
      final filename = element.library.source.shortName;
      final vibeFileName = filename.replaceAll('.dart', '.vibe.dart');
      final library = element.library;
      final alreadyContained = library.parts.any((part) {
        return part.name == vibeFileName;
      });
      if (alreadyContained) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        priority: 1,
        message: 'Insert part "$vibeFileName";',
      );

      final insertionPosition =
          (node.parent as CompilationUnit).directives.last.end;

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(
            insertionPosition, '\npart "$vibeFileName";\n');
      });
    });
  }
}
