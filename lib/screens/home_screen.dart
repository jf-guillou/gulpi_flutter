import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/api_config_model.dart';
import 'package:gulpi/models/appstate_model.dart';
import 'package:gulpi/models/searchoptions_model.dart';
import 'package:gulpi/screens/settings_screen.dart';
import 'package:gulpi/services/api_service.dart';
import 'package:gulpi/utilities/exceptions.dart';
import 'package:gulpi/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const name = "HomeScreen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(title: Text(l10n.home)),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _load(context),
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

              return const Placeholder();
            }),
        floatingActionButton: null);
  }

  Future<bool> _load(BuildContext context) async {
    AppState app = Provider.of<AppState>(context, listen: false);
    await app.loadState();
    APIService.instance.config = APIConfig.fromAppState(app);
    if (!APIService.instance.config.hasUri() ||
        !APIService.instance.config.hasAuth()) {
      log("missing config, goto settings");
      if (!context.mounted) return false;
      _toSettings(context, "Missing configuration");
      return false;
    }

    try {
      if (!APIService.instance.config.hasSession()) {
        String? session = await APIService.instance.initSession();
        if (session != null) {
          app.sessionToken = session;
        }
      }

      if (app.searchOptions == null) {
        await APIService.instance.searchOptions();
        app.searchOptions = SearchOptions.serialize();
      } else {
        SearchOptions.unserialize(app.searchOptions!);
        if (SearchOptions.isStale()) {
          await APIService.instance.searchOptions();
          app.searchOptions = SearchOptions.serialize();
        }
      }
    } on AppTokenException {
      _toSettings(context, "Wrong App token");
    } catch (e) {
      log("$e");
      return false;
    }

    return true;
  }

  void _toSettings(BuildContext context, String reason) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingsScreen()));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reason)));
  }
}
