import 'dart:convert';

import 'package:gulpi/models/itemstate_model.dart';

class ItemStates {
  static const Duration _stalenessThreshold = Duration(days: 7);
  DateTime? _updatedAt;
  List<ItemState> arr = [];

  ItemStates.fromJson(List<dynamic> json) : super() {
    _updatedAt = DateTime.now();
    arr = List.from(json.map((e) => ItemState.fromJson(e)));
  }

  bool isStale() {
    return _updatedAt == null ||
        _updatedAt!.add(_stalenessThreshold).isBefore(DateTime.now());
  }

  ItemState? getElementById(int id) {
    return arr.where((e) => e.id == id).firstOrNull;
  }

  ItemStates.unserialize(String str) {
    var j = json.decode(str);
    if (j == null) {
      return;
    }

    _updatedAt = DateTime.parse(j['updatedAt']);
    arr = List.from(j['arr'].map((e) => ItemState.fromJson(e)));
  }

  String serialize() {
    return json.encode({
      "updatedAt": _updatedAt!.toIso8601String(),
      "arr": arr,
    });
  }
}
