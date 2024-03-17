import 'package:flutter/material.dart';
import 'qr_scanner.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String brandName = "Showtime";
  String displayText = "";
  static const int _waitingTextTime = 1000;
  static const int _animationTime = 180;

  Future<void> performBrandingAnimation() async {
    Future.delayed(const Duration(milliseconds: _waitingTextTime), () {
      Timer.periodic(const Duration(milliseconds: _animationTime), (timer) {
        if (displayText == brandName) {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: _waitingTextTime), () {
            Navigator.pushReplacementNamed(context, '/QrScanner');
          });
        } else {
          setState(() {
            displayText = brandName.substring(0, displayText.length + 1);
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Start the timer to display the brand name
    performBrandingAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/showtime_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                displayText,
                style: const TextStyle(
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 14),
                child: const Text(
                  "Powered by\nEverySaturdayFreePopcorn",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Georgia',
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
