import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'movie_content.dart';

void main() => runApp(QrScanner());

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  bool _isCameraActive = false;
  String _scannedCode = '';
  MobileScannerController camController = MobileScannerController(
    autoStart: false,
    torchEnabled: true,
    detectionSpeed: DetectionSpeed.normal,
  );

  @override
  void initState() {
    super.initState();
  }

  Timer? _scanTimer;

  Future<void> scanQR() async {
    if (!await Permission.camera.request().isGranted) {
      debugPrint("Camera permission not granted");
      return;
    }
    if (_isCameraActive) {
      camController.start();

      _scanTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        try {
          Barcode barcode = (await camController.analyzeImage(BarcodeFormat.qrCode as String)) as Barcode;

          if (barcode.rawValue != null) {
            setState(() {
              _scannedCode = barcode.rawValue!;
            });
            _scanTimer?.cancel();
            camController.stop();
          }
        } catch (e) {
          // Handle potential camera errors
        }
      });
    }
  }

  @override
  void dispose() {
    camController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: camController,
            onDetect: (barcode) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieContent(scannedCode: barcode.raw ?? "Not found"),
                ),
              );
            },
            fit: BoxFit.cover,
          ),
          Visibility(
            visible: !_isCameraActive,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isCameraActive = true;
                  scanQR();
                });
              },
              child: const Text('Scan QR Code'),
            ),
          ),
          Visibility(
            visible: _isCameraActive,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isCameraActive = false;
                  _scanTimer?.cancel(); // Stop scanning if timer was still running
                  camController.stop();
                });
              },
              child: const Icon(Icons.stop),
            ),
          ),
        ],
      ),
    );
  }
}
