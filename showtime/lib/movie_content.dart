import 'package:flutter/material.dart';

class MovieContent extends StatefulWidget {
  final String scannedCode;

  const MovieContent({Key? key, required this.scannedCode}) : super(key: key);

  @override
  _MovieContentState createState() => _MovieContentState();
}

class _MovieContentState extends State<MovieContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Content'), // Adjust title as needed
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Scanned Code: ${widget.scannedCode}'),
            // Add widgets to display movie details based on the scanned code
          ],
        ),
      ),
    );
  }
}