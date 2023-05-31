import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/appstate_model.dart';
import 'package:gulpi/services/api_service.dart';
import 'package:gulpi/widgets/app_drawer.dart';
import 'package:gulpi/widgets/textfield_popup.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  static const name = "SettingsScreen";
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    AppState app = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      drawer: const AppDrawer(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(l10n.server),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.link),
                title: Text(l10n.glpiServerUrl),
                value: Text(app.url ?? l10n.notSet),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) => TextFieldPopup(
                              l10n.glpiServerUrl,
                              "https://glpi.example.com",
                              app.url ?? "", (String value) async {
                            if (!_urlValidator(value)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.malformedUrl)));
                              return;
                            }
                            API().config.setUrl(value);
                            setState(() {
                              app.url = value;
                            });
                          }));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock_outline),
                title: Text(l10n.appToken),
                value: Text(app.appToken ?? l10n.notSet),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) => TextFieldPopup(
                              l10n.appToken, "", app.appToken ?? l10n.notSet,
                              (String value) async {
                            API().config.setAppToken(value);
                            setState(() {
                              app.appToken = value;
                            });
                          }));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock_outline),
                title: Text(l10n.userToken),
                value: Text(app.userToken ?? l10n.notSet),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) => TextFieldPopup(
                              l10n.userToken, '', app.userToken ?? l10n.notSet,
                              (String value) async {
                            API().config.setUserToken(value);
                            setState(() {
                              app.userToken = value;
                            });
                          }));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.check),
                title: Text(l10n.validateServerInfo),
                onPressed: (context) async {
                  bool success = await API().checkUri();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(success ? l10n.ok : l10n.cannotReachUrl)));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _urlValidator(String? url) {
    if (url == null) return false;
    Uri? uri = Uri.tryParse(url);
    return uri != null &&
        (uri.isScheme("HTTPS") || uri.isScheme("HTTP")) &&
        uri.isAbsolute &&
        uri.host.isNotEmpty;
  }
}
