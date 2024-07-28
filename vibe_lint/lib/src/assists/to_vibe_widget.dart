import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final statelssWidget =
    TypeChecker.fromName('StatelessWidget', packageName: 'flutter');

class ConvertToVibeWidget extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    if (!context.pubspec.dependencies.keys.contains('vibe')) {
      return;
    }
    context.registry.addExtendsClause(
      (node) {
        node.superclass;
      },
    );
  }
}
