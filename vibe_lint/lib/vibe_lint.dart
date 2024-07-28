import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _VibeLinter();

class _VibeLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [VibeLintCode()];
  }
}

class VibeLintCode extends DartLintRule {
  VibeLintCode() : super(code: _code);
  static const _code = LintCode(
    name: 'vibe_lint',
    problemMessage: 'This is the description message',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      reporter.atNode(node, code);
    });
  }
}
