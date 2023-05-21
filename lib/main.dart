import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/loc.dart';
import 'package:gulpi/screens/scan_screen.dart';

void main() {
  runApp(const Gulpi());
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
        localizationsDelegates: Loc.localizationsDelegates,
        supportedLocales: Loc.supportedLocales,
        home: const ScanScreen());
  }
}
