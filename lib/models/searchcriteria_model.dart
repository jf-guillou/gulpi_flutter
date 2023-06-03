import 'dart:convert';

import 'package:gulpi/models/searchoption_model.dart';
import 'package:gulpi/services/cache_service.dart';
import 'package:gulpi/utilities/item_types.dart';

class SearchCriteria {
  int? field;
  String? searchtype;
  String? value;
  SearchLink link = SearchLink.and;
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
    link = SearchLink.or;
    return this;
  }

  SearchCriteria and() {
    link = SearchLink.and;
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
      "link": link.str(),
      "meta": meta,
      "itemtype": itemtype,
      "criteria": criteria,
    };
  }
}

enum SearchLink {
  and,
  or,
  andNot,
  orNot;

  String str() {
    switch (this) {
      case and:
        return "AND";
      case or:
        return "OR";
      case andNot:
        return "AND NOT";
      case orNot:
        return "OR NOT";
      default:
        return "";
    }
  }

  static List<SearchLink> all() {
    return [and, or, andNot, orNot];
  }
}
