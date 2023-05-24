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
                value: Text(app.url ?? "(not set)"),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) => TextFieldPopup(
                              "GLPI server URL",
                              "https://glpi.example.com",
                              app.url ?? "", (String value) async {
                            if (!_urlValidator(value)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Malformed url'),
                                ),
                              );
                              return;
                            }
                            APIService.instance.config.setUrl(value);
                            bool success = await APIService.instance.checkUri();
                            if (!success) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cannot reach url'),
                                ),
                              );
                              return;
                            }
                            app.url = value;
                            setState(() {});
                          }));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock_outline),
                title: Text('App token'),
                value: Text(app.appToken ?? '(not set)'),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          TextFieldPopup("App token", "", app.appToken ?? "",
                              (String value) async {
                            APIService.instance.config.setAppToken(value);
                            app.appToken = value;
                            setState(() {});
                          }));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock_outline),
                title: Text('User token'),
                value: Text(app.userToken ?? '(not set)'),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          TextFieldPopup("User token", "", app.userToken ?? "",
                              (String value) async {
                            APIService.instance.config.setUserToken(value);
                            app.userToken = value;
                            setState(() {});
                          }));
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
