import 'dart:convert';

import 'package:gulpi/models/searchoption_model.dart';
import 'package:gulpi/services/cache_service.dart';
import 'package:gulpi/utilities/item_types.dart';

class SearchCriteria {
  int? field;
  String? searchtype;
  String? value;
  String? link;
  bool? meta;
  String? itemtype;
  List<SearchCriteria>? criteria;
  final ItemType _type;
  SearchOption? _s;

  SearchCriteria(this._type);
  SearchCriteria.meta(this._type) {
    itemtype = _type.str;
    meta = true;
  }

  SearchCriteria uid(String uid) {
    _s = Cache().searchOptions[_type]!.getByUid(uid);
    if (_s == null) {
      throw "Unknown search option";
    }
    field = _s!.id;
    return this;
  }

  SearchCriteria searchType(String type) {
    if (_s == null) {
      throw "Unknown search option";
    }
    if (_s!.availableSearchtypes.contains(type)) {
      searchtype = type;
    }
    return this;
  }

  SearchCriteria contains(String str) {
    searchType("contains");
    value = str;
    return this;
  }

  SearchCriteria or() {
    link = "OR";
    return this;
  }

  SearchCriteria and() {
    link = "AND";
    return this;
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      "field": field,
      "searchtype": searchtype,
      "value": value,
      "link": link,
      "meta": meta,
      "itemtype": itemtype,
      "criteria": criteria,
    };
  }
}
