import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showtime/streaming_content.dart';
import 'package:showtime/utils.dart';

void main() => runApp(const QrScanner());

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

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

  Timer? _scanTimer;

  bool isDetected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      isDetected = true;
    });
    if (_isFlashlightActive) {
      toggleFlashlight();
    }
    stopScanner();
    super.dispose();
  }

  void onDetected(BarcodeCapture barcode) {
    if (barcode.raw == null) {
      alertDialog(context, "QR Detected", "Invalid QR code");
      debugPrint("\n\n\n\ invalid qrcode \n\n\n\n");
      return;
    }
    if (isDetected) {
      return;
    }
    setState(() {
      isDetected = true;
    });
    debugPrint("\n\n\n\nScanned code: ${barcode.raw}\nEnd of scan detected\n\n\n\n");
    var data = barcode.raw[0];

    const String videoId = "WOZfIgBR84Y";
    const String videoName = "Dune 2";

    return alertDialog(
      context,
      "QR Movie Detected",
      // "${data}",
      "Watch $videoName from Major Cineplex?",
      acceptText: "Watch $videoName",
      onAccept: () => goToStreamingContent(videoId),
      onCancel: () {
        setState(() {
          isDetected = false;
        });
      },
    );
  }

  void goToStreamingContent(String videoId) {
    dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamingContent(videoId: videoId),
      ),
    );
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
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}
