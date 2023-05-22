import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/appstate_model.dart';
import 'package:gulpi/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const Gulpi()));
}

class Gulpi extends StatelessWidget {
  const Gulpi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gulpi',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen());
  }
}
