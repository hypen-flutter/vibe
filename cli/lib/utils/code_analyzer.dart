import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';

class Analyzer {
  Analyzer(this.path);
  final List<String> path;
  late final AnalysisContextCollection contextCollection;

  AnalysisContext contextFor(String path) =>
      contextCollection.contextFor(path.absolutePath);

  Future<Set<String>> applyChanges(String path) async {
    final AnalysisContext context = contextFor(path)..changeFile(path);
    final List<String> changedFiles = await context.applyPendingFileChanges();
    return changedFiles.toSet()..add(path.absolutePath);
  }

  Future<LibraryElement?> libraryFor(String path) async {
    final AnalysisContext context = contextFor(path);
    final SomeResolvedLibraryResult result =
        await context.currentSession.getResolvedLibrary(path);

    return switch (result) {
      final ResolvedLibraryResult r => r.element,
      SomeResolvedLibraryResult() => null,
    };
  }
}

extension on String {
  String get absolutePath => File(this).absolute.path;
}
