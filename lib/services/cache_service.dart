import 'dart:developer';

import 'package:gulpi/models/computermodel_model.dart';
import 'package:gulpi/models/item_collection.dart';
import 'package:gulpi/models/itemstate_model.dart';
import 'package:gulpi/models/manufacturer_model.dart';
import 'package:gulpi/models/searchoptions_model.dart';
import 'package:gulpi/services/api_service.dart';
import 'package:gulpi/utilities/item_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static final Cache _instance = Cache._instantiate();
  Cache._instantiate();
  final Map<ItemType, SearchOptions?> searchOptions = {};
  ItemCollection<ItemState> itemStates = ItemCollection();
  ItemCollection<ComputerModel> computerModels = ItemCollection();
  ItemCollection<Manufacturer> manufacturers = ItemCollection();

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
    log('Cache.ItemState');
    String key = 'itemstates';
    if (prefs.containsKey(key)) {
      itemStates = ItemCollection<ItemState>.unserialize(
          prefs.getString(key)!, ItemState.fromJson);
    }
    if (itemStates.isStale()) {
      itemStates = await API().itemStates();
      prefs.setString(key, itemStates.serialize());
    }

    // ComputerModels
    log('Cache.ComputerModel');
    key = 'computermodels';
    if (prefs.containsKey(key)) {
      computerModels = ItemCollection<ComputerModel>.unserialize(
          prefs.getString(key)!, ComputerModel.fromJson);
    }
    if (computerModels.isStale()) {
      computerModels = await API().computerModels();
      prefs.setString(key, computerModels.serialize());
    }

    // Manufacturers
    log('Cache.Manufacturer');
    key = 'manufacturers';
    if (prefs.containsKey(key)) {
      manufacturers = ItemCollection<Manufacturer>.unserialize(
          prefs.getString(key)!, Manufacturer.fromJson);
    }
    if (manufacturers.isStale()) {
      manufacturers = await API().manufacturers();
      prefs.setString(key, manufacturers.serialize());
    }
  }
}
