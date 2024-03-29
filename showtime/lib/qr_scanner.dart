import 'dart:async';

import 'package:flutter/cupertino.dart';
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
    return;
  }

  void toggleFlashlight() async {
    setState(() {
      _isFlashlightActive = !_isFlashlightActive;
    });
    await camController.toggleTorch();
  }

  Future<void> startScanner() async {
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

  Future<void> stopScanner() async {
    if (_isCameraActive) {
      await camController.stop();
      setState(() {
        _isCameraActive = false;
      });
      _scanTimer?.cancel();
    }
  }

  Future<void> toggleScanner() async {
    if (_isCameraActive) {
      await stopScanner();
    } else {
      await startScanner();
    }
  }

  @override
  void dispose() {
    if (_isFlashlightActive) {
      toggleFlashlight();
    }
    stopScanner();
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
                startScanner();
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
              Positioned(
                bottom: 30, // Adjust spacing from bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _cameraActionButton(),
                    const SizedBox(width: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}
