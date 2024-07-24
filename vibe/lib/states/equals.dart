import 'package:collection/collection.dart';

final bool Function(Object? e1, Object? e2) deepEquals =
    const DeepCollectionEquality().equals;
