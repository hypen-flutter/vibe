import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final statelssWidget =
    TypeChecker.fromName('StatelessWidget', packageName: 'flutter');

class ConvertToVibeWidget extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addExtendsClause(
      (node) {
        if (node.toSource().contains('VibeWidget')) {
          return;
        }
        final changeBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Change to [VibeWidget]');
        changeBuilder.addDartFileEdit(
          (builder) {
            builder.addSimpleReplacement(
                node.sourceRange, 'extends VibeWidget');
          },
        );
      },
    );
  }
}
