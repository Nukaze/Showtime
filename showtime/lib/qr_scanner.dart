import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Import the new library
import 'movie_content.dart';
import 'dart:async';

void main() => runApp(QrScanner());

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String _scannedCode = '';
  MobileScannerController _cameraController = MobileScannerController(); // New controller

  Future<void> scanQR() async {
    // Start the camera controller
    bool isStarted = (await _cameraController.start()) as bool;

    if (isStarted) {
      // Analyze frames continuously
      try {
        Barcode barcode = (await _cameraController.analyzeImage(BarcodeFormat.qrCode as String)) as Barcode;

        if (barcode.rawValue != null) {
          setState(() {
            _scannedCode = barcode.rawValue!;
          });
          // ... Your navigation logic ...
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieContent(scannedCode: _scannedCode),
            ),
          );
        }
      } catch (e) {
        // Handle errors starting the scanner
      }
    } else {
      // Handle errors starting the scanner
    }
  }

  @override
  void dispose() {
    _cameraController.stop(); // Stop the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ... Your existing MaterialApp ...
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scan QR Ticket'),
        ),
        body: Builder(
          // Add a Builder to display the camera preview
          builder: (context) {
            return Stack(
              children: [
                MobileScanner(
                    controller: _cameraController,
                    fit: BoxFit.cover, // Adapt as needed
                    onDetect: (barcode) {
                      // ... Your navigation logic ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieContent(scannedCode: barcode.raw),
                        ),
                      );
                    }),
                // ... Your other UI elements ...
              ],
            );
          },
        ),
      ),
    );
  }
}
