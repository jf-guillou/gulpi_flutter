import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/widgets/app_drawer.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  static const name = "SettingsScreen";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      drawer: const AppDrawer(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                value: Text('English'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Server'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.link),
                title: Text('GLPI server URL'),
                value: Text('https://glpi.example.com'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock_outline),
                title: Text('Token'),
                value: Text('(not set)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
