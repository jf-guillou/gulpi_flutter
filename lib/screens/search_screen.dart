import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/screens/inventory_screen.dart';
import 'package:gulpi/screens/scan_screen.dart';
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
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ScanScreen(),
                settings: const RouteSettings(name: ScanScreen.name)));
          },
          child: const Icon(Icons.photo_camera_outlined)),
    );
  }

  bool _isValidBarcode(String barcode) {
    // TODO: _isValidBarcode
    return true;
  }

  Future<String> _lookupGLPI(String id) async {
    // TODO: _lookupGLPI
    await Future.delayed(const Duration(seconds: 2));
    return "1";
  }
}
