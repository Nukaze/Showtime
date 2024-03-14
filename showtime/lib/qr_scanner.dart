import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'movie_content.dart'; // Import your second page

void main() => runApp(QrScanner());

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String _scannedCode = '';

  Future<void> scanQR() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR
    );
    if (barcodeScanRes.isNotEmpty) {
      setState(() {
        _scannedCode = barcodeScanRes;
      });
      // Navigate to ticket details page with scanned code (optional)
      Navigator.push(context,
          MaterialPageRoute(
              builder:(context) => MovieContent(scannedCode: _scannedCode))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Ticket Scanner',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scan QR Ticket'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: scanQR,
                child: Text('Scan QR Code'),
              ),
              Text(_scannedCode, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}