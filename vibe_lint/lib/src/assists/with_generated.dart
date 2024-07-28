import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class WithGeneratedClass extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addClassDeclaration((node) {
      if (!target.intersects(node.sourceRange)) {
        // check cursor position
        return;
      }
      final element = node.declaredElement;
      if (element == null) {
        return;
      }
      final changeBuilder = reporter.createChangeBuilder(
          priority: 1, message: 'Mixin with _${element.name}');

      final insertionPosition = node.extendsClause?.end ?? node.name.end;

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(insertionPosition, ' with _${element.name}');
      });
    });
  }
}
