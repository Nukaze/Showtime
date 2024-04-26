import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showtime/custom_navbar.dart';
import 'package:showtime/streaming_content.dart';
import 'package:showtime/utils.dart';

import 'main.dart';

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
    var data = barcode.raw[0];

    const String videoId = "WOZfIgBR84Y";
    const String videoName = "Dune 2";

    setState(() {
      isDetected = true;
      Global().videoId = videoId;
    });
    debugPrint(
        "\n\n\n\nScanned code: ${barcode.raw}\nEnd of scan detected\n\n\n\n");

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
        return;
      },
    );
  }

  void goToStreamingContent(String videoId) {
    dispose();
    Navigator.pop(context);
    // no trasition animation
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StreamingContent(videoId: videoId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; // No transition animation
        },
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
      _scanTimer =
          Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        try {
          Barcode barcode = (await camController
              .analyzeImage(BarcodeFormat.qrCode as String)) as Barcode;

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
              Navigator.pop(context);
              Navigator.pushNamed(context, '/QrScanner');
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

  Widget _buildHorizontalMoviesPoster() {
    List<String> moviePosters = [
      'assets/images/poster_dune2.jpg',
      'assets/images/poster_aprilcome.jpg',
      'assets/images/poster_civilwar.jpg',
      'assets/images/poster_exhuma.jpg',
      'assets/images/poster_gxk.jpg',
    ];

    List<String> movieTitles = [
      'Dune 2',
      'April Come She Will',
      'Civil War',
      'Exhuma',
      'GXK',
    ];

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 600,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moviePosters.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              // Adjust the border radius as needed
              child: Image.asset(
                moviePosters[index],
                width: 350,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                Positioned(
                  top: 30,
                  child: _buildHorizontalMoviesPoster(),
                ),
                MobileScanner(
                  controller: camController,
                  onDetect: onDetected,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 25, // Adjust spacing from bottom
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _cameraActionButton(),
                      const SizedBox(width: 20),
                      Visibility(
                        visible: _isCameraActive,
                        child: FloatingActionButton(
                          onPressed: toggleFlashlight,
                          backgroundColor: (_isFlashlightActive)
                              ? (Colors.tealAccent)
                              : (Colors.grey),
                          child: Icon(_isFlashlightActive
                              ? Icons.flashlight_on
                              : Icons.flashlight_off),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          initialIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
