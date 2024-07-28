import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

import 'path.dart';

class Analyzer {
  Analyzer(this.path);
  final List<String> path;
  late final AnalysisContextCollection contextCollection =
      AnalysisContextCollection(includedPaths: path);

  AnalysisContext _contextFor(String path) {
    final String relativePath = p.relative(path);
    if (relativePath.startsWith('bin')) {
      return contextCollection.contextFor('bin'.absolutePath);
    } else if (relativePath.startsWith('lib')) {
      return contextCollection.contextFor('lib'.absolutePath);
    } else if (relativePath.startsWith('test')) {
      return contextCollection.contextFor('test'.absolutePath);
    }
    return contextCollection.contextFor(path.absolutePath);
  }

  Future<Set<String>> applyChanges(String path) async {
    final AnalysisContext context = _contextFor(path)..changeFile(path);
    final List<String> changedFiles = await context.applyPendingFileChanges();
    return changedFiles.toSet()..add(path.absolutePath);
  }

  Future<LibraryElement?> libraryFor(String path) async {
    final AnalysisContext context = _contextFor(path);
    final SomeResolvedLibraryResult result =
        await context.currentSession.getResolvedLibrary(path);

    return switch (result) {
      final ResolvedLibraryResult r => r.element,
      SomeResolvedLibraryResult() => null,
    };
  }
}
