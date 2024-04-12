import 'package:flutter/material.dart';
import 'qr_scanner.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Showtime',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      home: const SplashScreen(),
      routes: {
        '/SplashScreen': (context) => const SplashScreen(),
        '/QrScanner': (context) => const QrScanner(),

        // '/MovieContent': (context, _scannedCode) => MovieContent(scannedCode: _scannedCode),
      },
    );
  }
}
