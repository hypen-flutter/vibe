import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final statelssWidget =
    TypeChecker.fromName('StatelessWidget', packageName: 'flutter');

class ConvertToVibeStatefulWidget extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addClassDeclaration(
      (node) {
        final extendsClause = node.extendsClause;
        if (extendsClause == null) {
          return;
        }
        if (extendsClause.toSource().contains('VibeStatefulWidget')) {
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final className = node.declaredElement!.name;
        final _ = '_${className}State';

        final vibeWidgetStatePosition = node.end;

        final changeBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Change to [VibeStatefulWidget]');
        changeBuilder.addDartFileEdit(
          (builder) {
            builder.addSimpleReplacement(
                extendsClause.sourceRange, 'extends VibeStatefulWidget');
            builder.addSimpleInsertion(
              vibeWidgetStatePosition,
              '''
''',
            );
          },
        );
      },
    );
  }
}
