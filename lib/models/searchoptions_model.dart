import 'dart:convert';

import 'package:gulpi/models/searchoption_model.dart';

class SearchOptions {
  static const Duration _stalenessThreshold = Duration(days: 7);
  DateTime? _updatedAt;
  List<SearchOption> arr = [];

  SearchOptions.fromJson(Map<String, dynamic> json) : super() {
    _updatedAt = DateTime.now();
    String? currentCat;
    json.forEach((key, value) {
      int? intKey = int.tryParse(key);
      if (intKey != null) {
        SearchOption opt = SearchOption.fromJson(value);
        opt.id = intKey;
        opt.cat = currentCat;
        arr.add(opt);
      } else {
        currentCat = key;
      }
    });
  }

  SearchOption? getById(int id) {
    return arr.where((e) => e.id == id).firstOrNull;
  }

  SearchOption? getByUid(String uid) {
    return arr.where((e) => e.uid == uid).firstOrNull;
  }

  bool isStale() {
    return _updatedAt == null ||
        _updatedAt!.add(_stalenessThreshold).isBefore(DateTime.now());
  }

  SearchOptions.unserialize(String str) {
    var j = json.decode(str);
    if (j == null) {
      return;
    }

    _updatedAt = DateTime.parse(j['updatedAt']);
    arr = List.from(j['arr'].map((e) => SearchOption.fromJson(e)));
  }

  String serialize() {
    return json.encode({
      "updatedAt": _updatedAt!.toIso8601String(),
      "arr": arr,
    });
  }
}
