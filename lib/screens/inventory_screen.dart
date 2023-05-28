import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/computer_model.dart';
import 'package:gulpi/screens/scan_screen.dart';
import 'package:gulpi/services/api_service.dart';
import 'package:gulpi/services/cache_service.dart';
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
  Computer? _item;
  Computer? _remoteItem;

  @override
  Widget build(BuildContext context) {
    log("InventoryScreen");
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventory)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () async {
            await _fetchComputer(widget.id);
            setState(() {});
          },
          child: FutureBuilder(
              future: _getComputer(widget.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }

                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        ListTile(title: Text(l10n.assetTag(_item!.assetTag))),
                        ListTile(title: Text(l10n.name(_item!.name))),
                        ListTile(
                            title: Text(
                                l10n.status(Cache.instance.itemStates!
                                    .getElementById(_item!.state)!
                                    .name),
                                style: _item!.state != _remoteItem!.state
                                    ? TextStyle(fontWeight: FontWeight.bold)
                                    : null),
                            trailing: PopupMenuButton(
                              onSelected: (v) {
                                setState(() {
                                  _item!.state = v;
                                });
                              },
                              itemBuilder: (context) => Cache
                                  .instance.itemStates!.arr
                                  .map((e) => PopupMenuItem(
                                      value: e.id, child: Text(e.name)))
                                  .toList(),
                            )),
                        FilledButton.tonal(
                            onPressed: () {}, child: Text(l10n.addNote)),
                        FilledButton(
                            onPressed: () async {
                              if (await _saveChanges(widget.id) && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.changesSaved)));
                              }
                            },
                            child: Text(l10n.saveChanges)),
                      ],
                    ));
              })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ScanScreen(),
                settings: const RouteSettings(name: ScanScreen.name)));
          },
          child: const Icon(Icons.photo_camera_outlined)),
    );
  }

  Future<Computer?> _getComputer(String id) async {
    if (_item != null) {
      return _item;
    }

    return _fetchComputer(id);
  }

  Future<Computer?> _fetchComputer(String id) async {
    Computer item = await API.instance.getItem(id) as Computer;
    item.assetTag = widget.tag;
    setState(() {
      _item = item;
    });
    _remoteItem = item.clone();

    return item;
  }

  Future<bool> _saveChanges(String id) async {
    Map<String, dynamic> fields = _item!.diff(_remoteItem!);
    if (fields.isEmpty) {
      return false;
    }
    bool saved = await API.instance.updateItem(id, fields);
    await _fetchComputer(id);
    return saved;
  }
}
