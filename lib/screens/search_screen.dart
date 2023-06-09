import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/paginable_model.dart';
import 'package:gulpi/models/searchcriteria_model.dart';
import 'package:gulpi/models/searchcriterion_model.dart';
import 'package:gulpi/models/searchitem_model.dart';
import 'package:gulpi/screens/inventory_screen.dart';
import 'package:gulpi/screens/scan_screen.dart';
import 'package:gulpi/services/api_service.dart';
import 'package:gulpi/utilities/item_types.dart';
import 'package:gulpi/widgets/app_drawer.dart';
import 'package:gulpi/widgets/searchcriteria_listtile.dart';

class SearchScreen extends StatefulWidget {
  static const name = "SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<SearchCriterionListTile> _searchCriterion = [
    const SearchCriterionListTile(position: 0)
  ];

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.search)),
      drawer: const AppDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              // TODO: setup onChange in SearchCriterionListTile
              ..._searchCriterion,
              ListTile(
                  title: Row(children: [
                FilledButton.tonal(
                    onPressed: _addCriteria, child: const Icon(Icons.add)),
                FilledButton.tonal(
                    onPressed:
                        _searchCriterion.length > 1 ? _removeCriteria : null,
                    child: const Icon(Icons.remove))
              ])),
              FilledButton(
                  onPressed: () async {
                    SearchCriterion c = SearchCriterion(ItemType.computer);
                    c.add(SearchCriteria(c.type)
                        .uid("Computer.name")
                        .contains(""));
                    String? id = await _lookupGLPI(c);
                    if (id == null || !mounted) {
                      return;
                    }

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InventoryScreen(id),
                        settings:
                            const RouteSettings(name: InventoryScreen.name)));
                  },
                  child: Text(l10n.search)),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ScanScreen(),
                settings: const RouteSettings(name: ScanScreen.name)));
          },
          child: const Icon(Icons.photo_camera_outlined)),
    );
  }

  Future<String?> _lookupGLPI(SearchCriterion sc) async {
    log("_lookupGLPI");
    Paginable<SearchItem> items = await API().searchItems(sc);
    if (items.count == 0) {
      return null;
    }

    return items.items.first.id;
  }

  void _addCriteria() {
    setState(() {
      _searchCriterion
          .add(SearchCriterionListTile(position: _searchCriterion.length));
    });
  }

  void _removeCriteria() {
    setState(() {
      _searchCriterion.removeLast();
    });
  }
}
