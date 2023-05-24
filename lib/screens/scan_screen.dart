import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/screens/inventory_screen.dart';
import 'package:gulpi/screens/search_screen.dart';
import 'package:gulpi/widgets/app_drawer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  static const name = "ScanScreen";
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _hasActiveLookup = false;

  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scan),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front, color: Colors.grey);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear, color: Colors.grey);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) async {
          if (_hasActiveLookup) {
            return;
          }
          _hasActiveLookup = true;
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue == null) {
              continue;
            }

            String rawBarcode = barcode.rawValue!;
            log("Found barcode $rawBarcode");
            if (!_isValidBarcode(rawBarcode)) {
              continue;
            }

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(l10n.loading),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 15),
                    Text(l10n.lookupInGLPI(rawBarcode)),
                  ]),
                );
              },
            );
            late String id;
            try {
              id = await _lookupGLPI(rawBarcode);
            } catch (e) {
              if (!context.mounted) {
                return;
              }
              // Remove AlertDialog
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.lookupFailed)),
              );
              continue;
            }

            log("Lookup result $id");
            // ignore: use_build_context_synchronously
            if (!context.mounted) {
              return;
            }
            // Remove AlertDialog
            Navigator.of(context).pop();

            if (id.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.notFound)),
              );
              continue;
            }

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => InventoryScreen(rawBarcode, id),
                settings: const RouteSettings(name: InventoryScreen.name)));
            return;
          }
          _hasActiveLookup = false;
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SearchScreen(),
                settings: const RouteSettings(name: SearchScreen.name)));
          },
          child: const Icon(Icons.search)),
    );
  }

  bool _isValidBarcode(String barcode) {
    return barcode.length > 3 && barcode.length < 20;
  }

  Future<String> _lookupGLPI(String id) async {
    // TODO: _lookupGLPI
    await Future.delayed(const Duration(seconds: 2));
    return "1";
  }
}
