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
  @override
  Widget build(BuildContext context) {
    log("InventoryScreen");
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventory)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () async {
            // FIXME : this triggers rebuild & double API call ?
            await _getComputer(widget.id);
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

                final Computer item = snapshot.data!;
                item.assetTag = widget.tag;
                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        ListTile(title: Text(l10n.assetTag(item.assetTag))),
                        ListTile(title: Text(l10n.name(item.name))),
                        ListTile(
                            title: Text(l10n.status(Cache.instance.itemStates!
                                .getElementById(item.state)!
                                .name)),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => Cache
                                  .instance.itemStates!.arr
                                  .map((e) => PopupMenuItem(
                                      value: e.id, child: Text(e.name)))
                                  .toList(),
                            )),
                        FilledButton.tonal(
                            onPressed: () {}, child: Text(l10n.addNote)),
                        FilledButton(
                            onPressed: () {}, child: Text(l10n.saveChanges)),
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
    return await API.instance.getItem(id) as Computer;
  }
}
