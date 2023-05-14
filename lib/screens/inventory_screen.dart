import 'dart:developer';

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              ListTile(title: Text('Tag : ${widget.tag}')),
              const ListTile(title: Text('Name : pc-veil-123456')),
              ListTile(
                  title: Row(children: [
                const Text('Status : OK'),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 1, child: Text('OK')),
                    const PopupMenuItem(value: 2, child: Text('Not OK')),
                  ],
                )
              ])),
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
