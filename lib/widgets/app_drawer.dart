import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/screens/home_screen.dart';
import 'package:gulpi/screens/scan_screen.dart';
import 'package:gulpi/screens/search_screen.dart';
import 'package:gulpi/screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    String? route = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Gulpi',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 42.0,
                          decoration: TextDecoration.none)))
            ]),
          ),
          ListTile(
            title: Text(l10n.home),
            leading: const Icon(Icons.home),
            selected: route == HomeScreen.name,
            onTap: () {
              if (route == HomeScreen.name) {
                Navigator.pop(context);
                return;
              }
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                  settings: const RouteSettings(name: HomeScreen.name)));
            },
          ),
          ListTile(
            title: Text(l10n.search),
            leading: const Icon(Icons.search),
            selected: route == SearchScreen.name,
            onTap: () {
              if (route == SearchScreen.name) {
                Navigator.pop(context);
                return;
              }
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                  settings: const RouteSettings(name: SearchScreen.name)));
            },
          ),
          ListTile(
            title: Text(l10n.scan),
            leading: const Icon(Icons.camera_alt_outlined),
            selected: route == ScanScreen.name,
            onTap: () {
              if (route == ScanScreen.name) {
                Navigator.pop(context);
                return;
              }
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ScanScreen(),
                  settings: const RouteSettings(name: ScanScreen.name)));
            },
          ),
          ListTile(
            title: Text(l10n.settings),
            leading: const Icon(Icons.settings),
            selected: route == SettingsScreen.name,
            onTap: () {
              if (route == SettingsScreen.name) {
                Navigator.pop(context);
                return;
              }
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                  settings: const RouteSettings(name: SettingsScreen.name)));
            },
          ),
        ],
      ),
    );
  }
}
