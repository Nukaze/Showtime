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
  bool _isFlashlightActive = false;
  String _scannedCode = '';
  MobileScannerController camController = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
    detectionSpeed: DetectionSpeed.normal,
  );

  @override
  void initState() {
    super.initState();
  }

  Timer? _scanTimer;

  void onDetected(BarcodeCapture barcode) {
    if (barcode.raw == null) {
      return;
    }
    dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieContent(scannedCode: barcode.raw ?? "Not found"),
      ),
    );
  }

  void toggleFlashlight() async {
    setState(() {
      _isFlashlightActive = !_isFlashlightActive;
    });
    await camController.toggleTorch();
  }

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
            dispose();
          }
        } catch (e) {
          // Handle potential camera errors
        }
      });
    }
  }

  @override
  void dispose() {
    if (_isFlashlightActive) {
      toggleFlashlight();
    }
    _isCameraActive = false;
    _scanTimer?.cancel();
    camController.dispose();
    super.dispose();
  }

  Widget _cameraActionButton() {
    return _isCameraActive
        ? FloatingActionButton(
            onPressed: () {
              dispose();
            },
            child: const Icon(Icons.stop),
          )
        : ElevatedButton(
            onPressed: () {
              setState(() {
                _isCameraActive = true;
                scanQR();
              });
            },
            child: const Text('Scan QR Code'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.tealAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/showtime_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              MobileScanner(
                controller: camController,
                onDetect: onDetected,
                fit: BoxFit.cover,
              ),
              _cameraActionButton(),
              Visibility(
                visible: _isCameraActive,
                child: FloatingActionButton(
                  onPressed: toggleFlashlight,
                  backgroundColor: (_isFlashlightActive) ? (Colors.tealAccent) : (Colors.grey),
                  child: Icon(_isFlashlightActive ? Icons.flashlight_on : Icons.flashlight_off),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
