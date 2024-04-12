import 'package:flutter/material.dart';
import 'qr_scanner.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class Global {
  static Global? _instance;
  String? videoId;
  int? currentIndex;

  factory Global() {
    _instance ??= Global._();
    return _instance!;
  }

  Global._();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  final String videoId = "WOZfIgBR84Y";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Showtime',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      // home: const SplashScreen(),
      initialRoute: '/SplashScreen',
      routes: {
        '/SplashScreen': (context) => const SplashScreen(),
        '/QrScanner': (context) => const QrScanner(),
        '/Shopping': (context) => Container(),
        '/Profile': (context) => Container(),
      },
    );
  }
}
