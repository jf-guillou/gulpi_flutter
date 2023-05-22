import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const name = "SettingsScreen";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      drawer: const AppDrawer(),
      body: Placeholder(),
    );
  }
}
