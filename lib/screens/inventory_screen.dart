import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/item_model.dart';
import 'package:gulpi/screens/scan_screen.dart';
import 'package:gulpi/widgets/app_drawer.dart';

class InventoryScreen extends StatefulWidget {
  static const name = "InventoryScreen";
  final String tag;
  final String id;
  const InventoryScreen(this.tag, this.id, {super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _item = Item.readJson({"id": "1"});

  @override
  Widget build(BuildContext context) {
    log("InventoryScreen");
    AppLocalizations l10n = AppLocalizations.of(context)!;
    _item.assetTag = widget.tag;
    _item.name = "test-name";
    _item.status = "OK";
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventory)),
      drawer: const AppDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              ListTile(title: Text(l10n.assetTag(_item.assetTag ?? ""))),
              ListTile(title: Text(l10n.name(_item.name ?? ""))),
              ListTile(
                  title: Text(l10n.status(_item.status ?? "")),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 1, child: Text(l10n.ok)),
                      PopupMenuItem(value: 2, child: Text(l10n.ko)),
                    ],
                  )),
              FilledButton.tonal(onPressed: () {}, child: Text(l10n.addNote)),
              FilledButton(onPressed: () {}, child: Text(l10n.saveChanges)),
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
}
