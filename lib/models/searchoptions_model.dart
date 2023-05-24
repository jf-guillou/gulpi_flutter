import 'dart:convert';

import 'package:gulpi/models/searchoption_model.dart';

class SearchOptions {
  static DateTime? _updatedAt;
  static const Duration _stalenessThreshold = Duration(days: 7);
  static List<SearchOption> arr = [];

  SearchOptions.readJson(Map<String, dynamic> json) : super() {
    _updatedAt = DateTime.now();
    String? currentCat;
    json.forEach((key, value) {
      int? intKey = int.tryParse(key);
      if (intKey != null) {
        SearchOption opt = SearchOption.readJson(value);
        opt.id = intKey;
        opt.cat = currentCat;
        arr.add(opt);
      } else {
        currentCat = key;
      }
    });
  }

  static SearchOption? fromUid(String uid) {
    return arr.where((e) => e.uid == uid).firstOrNull;
  }

  static bool isStale() {
    return _updatedAt == null ||
        _updatedAt!.add(_stalenessThreshold).isBefore(DateTime.now());
  }

  static void unserialize(String str) {
    var j = json.decode(str);
    if (j == null) {
      return;
    }

    _updatedAt = j['updatedAt'];
    arr = j['arr'];
  }

  static String serialize() {
    return json.encode({
      "updatedAt": _updatedAt,
      "arr": arr,
    });
  }
}
