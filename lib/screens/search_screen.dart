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
import 'package:gulpi/widgets/app_drawer.dart';

class SearchScreen extends StatefulWidget {
  static const name = "SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.search)),
      drawer: const AppDrawer(),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ScanScreen(),
                settings: const RouteSettings(name: ScanScreen.name)));
          },
          child: const Icon(Icons.photo_camera_outlined)),
    );
  }

  Future<String?> _lookupGLPI(String id) async {
    SearchCriterion c = SearchCriterion();
    c.add(SearchCriteria().uid("Computer.name").contains(id));
    c.add(SearchCriteria().or().uid("Computer.serial").contains(id));
    c.add(SearchCriteria().or().uid("Computer.otherserial").contains(id));
    Paginable<SearchItem> items = await APIService.instance.searchItems(c);
    if (items.count == 0) {
      return null;
    }

    return null;
  }
}
