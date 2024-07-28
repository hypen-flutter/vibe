import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:vibe_lint/src/assists/inject_part.dart';
import 'package:vibe_lint/src/assists/with_generated.dart';

PluginBase createPlugin() => _VibeLinter();

class _VibeLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [];
  }

  @override
  List<Assist> getAssists() {
    return [
      WithGeneratedClass(),
      InjectPartAssist(),
    ];
  }
}
