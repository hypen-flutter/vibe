import 'package:vibe/vibe.dart';

part 'collection_example.vibe.dart';

@Vibe(autoDispose: true)
class Collection with _Collection {
  Collection();
  List<int> list = [];
  Set<int> set = {};
  Map<int, int> map = {};
}
