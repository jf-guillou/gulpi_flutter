import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gulpi/screens/inventory_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
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
                  title: const Text('Loading'),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Lookup $rawBarcode in GLPI"),
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
                const SnackBar(
                  content: Text('Lookup failed'),
                ),
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
                const SnackBar(
                  content: Text('Not found'),
                ),
              );
              continue;
            }

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => InventoryScreen(rawBarcode, id)));
            return;
          }
          _hasActiveLookup = false;
        },
      ),
    );
  }

  bool _isValidBarcode(String barcode) {
    // TODO: _isValidBarcode
    return true;
  }

  Future<String> _lookupGLPI(String id) async {
    // TODO: _lookupGLPI
    await Future.delayed(const Duration(seconds: 2));
    return "1";
  }
}
