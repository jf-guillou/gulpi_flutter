import 'dart:convert';

import 'package:gulpi/models/item_model.dart';

typedef Itemizer<S> = S Function(Map<String, dynamic> item);

class ItemCollection<T extends Item> {
  static const Duration _stalenessThreshold = Duration(days: 7);
  DateTime? _updatedAt;
  List<T> arr = [];

  ItemCollection();

  bool isStale() {
    return _updatedAt == null ||
        _updatedAt!.add(_stalenessThreshold).isBefore(DateTime.now());
  }

  ItemCollection.fromJson(List<dynamic> json, Itemizer<T> itemizer) {
    _updatedAt = DateTime.now();
    arr = List.from(json.map((e) => itemizer(e)));
  }

  ItemCollection.unserialize(String str, Itemizer<T> itemizer) {
    var j = json.decode(str);
    if (j == null) {
      return;
    }

    _updatedAt = DateTime.parse(j['updatedAt']);
    arr = List.from(j['arr'].map((e) => itemizer(e)));
  }

  String serialize() {
    return json.encode({
      "updatedAt": _updatedAt!.toIso8601String(),
      "arr": arr,
    });
  }

  T? getById(int id) {
    return arr.where((e) => e.id == id).firstOrNull;
  }
}
