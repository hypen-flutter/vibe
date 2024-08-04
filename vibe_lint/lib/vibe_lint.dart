import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:vibe_lint/src/assists/add_vibe_annotation.dart';
import 'package:vibe_lint/src/assists/inject_part.dart';
import 'package:vibe_lint/src/assists/to_vibe_widget.dart';
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
      ConvertToVibeWidget(),
      AddVibeAnnotations(),
    ];
  }
}
