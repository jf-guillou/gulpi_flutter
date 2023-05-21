import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/screens/scan_screen.dart';

class InventoryScreen extends StatefulWidget {
  final String tag;
  final String id;
  const InventoryScreen(this.tag, this.id, {super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    log("InventoryScreen");
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              ListTile(title: Text(l10n.assetTag(widget.tag))),
              ListTile(title: Text(l10n.computerName("pc-veil-123456"))),
              ListTile(
                  title: Text(l10n.status("OK")),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 1, child: Text('OK')),
                      const PopupMenuItem(value: 2, child: Text('Not OK')),
                    ],
                  )),
              FilledButton.tonal(onPressed: () {}, child: Text(l10n.addNote)),
              FilledButton(onPressed: () {}, child: const Text('Save changes')),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScanScreen()));
          },
          child: const Icon(Icons.photo_camera_outlined)),
    );
  }
}
