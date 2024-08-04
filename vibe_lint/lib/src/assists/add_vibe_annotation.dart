import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AddVibeAnnotations extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addClassDeclaration(
      (node) {
        if (!target.intersects(node.sourceRange)) {
          // check cursor position
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final vibeAnnotationBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Add `@Vibe()` annotation');
        final insertion = node.offset;
        vibeAnnotationBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(insertion, '@Vibe() ');
        });
      },
    );

    context.registry.addConstructorDeclaration(
      (node) {
        if (!target.intersects(node.sourceRange)) {
          // check cursor position
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final externalKeyword = element.isExternal ? '' : 'external ';
        final factoryKeyword = element.isFactory ? '' : 'factory ';
        final vibeAnnotationBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Add `@Computed()` annotation');
        final insertion = node.offset;
        vibeAnnotationBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(
              insertion, '@Computed() $externalKeyword $factoryKeyword');
        });
      },
    );

    context.registry.addClassMember(
      (node) {
        if (!target.intersects(node.sourceRange)) {
          // check cursor position
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final vibeAnnotationBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Add `@LinkVibe()` annotation');
        final insertion = node.offset;
        vibeAnnotationBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(insertion, '@LinkVibe() ');
        });
      },
    );
    context.registry.addClassMember(
      (node) {
        if (!target.intersects(node.sourceRange)) {
          // check cursor position
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final vibeAnnotationBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Add `@SelectVibe([])` annotation');
        final insertion = node.offset;
        vibeAnnotationBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(insertion, '@SelectVibe([]) ');
        });
      },
    );

    context.registry.addClassMember(
      (node) {
        if (!target.intersects(node.sourceRange)) {
          // check cursor position
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final vibeAnnotationBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Add `@StreamVibe([])` annotation');
        final insertion = node.offset;
        vibeAnnotationBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(insertion, '@StreamVibe([]) ');
        });
      },
    );

    context.registry.addClassDeclaration(
      (node) {
        if (!target.intersects(node.sourceRange)) {
          // check cursor position
          return;
        }
        final element = node.declaredElement;
        if (element == null) {
          return;
        }

        final vibeAnnotationBuilder = reporter.createChangeBuilder(
            priority: 1, message: 'Add `@WithVibe([])` annotation');
        final insertion = node.offset;
        vibeAnnotationBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(insertion, '@WithVibe([]) ');
        });
      },
    );
  }
}
