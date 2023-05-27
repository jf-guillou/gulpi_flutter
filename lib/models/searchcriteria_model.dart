import 'dart:convert';

import 'package:gulpi/models/searchoption_model.dart';
import 'package:gulpi/models/searchoptions_model.dart';

class SearchCriteria {
  int? field;
  String? searchtype;
  String? value;
  String? link;
  bool? meta;
  String? itemtype;
  List<SearchCriteria>? criteria;
  SearchOption? _s;

  SearchCriteria uid(String uid) {
    _s = SearchOptions.fromUid(uid);
    if (_s == null) {
      throw "Unknown search option";
    }
    field = _s!.id;
    return this;
  }

  SearchCriteria _searchType(String type) {
    if (_s == null) {
      throw "Unknown search option";
    }
    if (_s!.availableSearchtypes.contains(type)) {
      searchtype = type;
    }
    return this;
  }

  SearchCriteria contains(String str) {
    _searchType("contains");
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

  Map toJson() {
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
