import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/appstate_model.dart';
import 'package:gulpi/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const name = "HomeScreen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    AppState app = Provider.of<AppState>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: Text(l10n.home)),
        drawer: const AppDrawer(),
        body: Placeholder(),
        floatingActionButton: null);
  }
}
