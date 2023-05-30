import 'dart:developer';

import 'package:gulpi/models/item_collection.dart';
import 'package:gulpi/models/itemstate_model.dart';
import 'package:gulpi/models/searchoptions_model.dart';
import 'package:gulpi/services/api_service.dart';
import 'package:gulpi/utilities/item_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static final Cache _instance = Cache._instantiate();
  Cache._instantiate();
  final Map<ItemType, SearchOptions?> searchOptions = {};
  ItemCollection<ItemState>? itemStates;

  factory Cache() => _instance;

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // SearchOptions
    log('Cache.SearchOptions');
    for (var it in ItemType.searchable()) {
      String key = 'searchoptions.$it';
      if (prefs.containsKey(key)) {
        searchOptions[it] = SearchOptions.unserialize(prefs.getString(key)!);
      }
      if (searchOptions[it] == null || searchOptions[it]!.isStale()) {
        searchOptions[it] = await API().searchOptions();
        prefs.setString(key, searchOptions[it]!.serialize());
      }
    }

    // States
    log('Cache.States');
    String key = 'itemstates';
    if (prefs.containsKey(key)) {
      itemStates = ItemCollection<ItemState>.unserialize(
          prefs.getString(key)!, ItemState.fromJson);
    }
    if (itemStates == null || itemStates!.isStale()) {
      itemStates = await API().itemStates();
      prefs.setString(key, itemStates!.serialize());
    }
  }
}
