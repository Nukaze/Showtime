import 'package:flutter/material.dart';
import 'package:showtime/profile_page.dart';
import 'package:showtime/qr_scanner.dart';
import 'package:showtime/shopping_list.dart';
import 'package:showtime/streaming_content.dart';
import 'package:showtime/utils.dart';

import 'main.dart';

class CustomNavBar extends StatefulWidget {
  final int initialIndex;
  final void Function(int)? onItemSelected;

  const CustomNavBar({
    Key? key,
    required this.initialIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTap(int newIndex) {
    if (newIndex == 1 &&
        (Global().videoId == null || Global().videoId!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          dismissDirection: DismissDirection.vertical,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: const Text(
              'Video id not available. \nPlease scan a QR code before using this menu.'),
          backgroundColor: Colors.red.shade800,
          action: SnackBarAction(
            label: 'x',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }
    if (newIndex == _currentIndex) {
      return;
    }
    setState(() {
      _currentIndex = newIndex;
    });
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(newIndex);
    }

    switch (newIndex) {
      case 0:
        alertDialog(
          context,
          'QR Code Scanner',
          'Go to Scanner.',
        );
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const QrScanner(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child; // No transition animation
            },
          ),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StreamingContent(videoId: Global().videoId!),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child; // No transition animation
            },
          ),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ShoppingList(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child; // No transition animation
            },
          ),
        );
        break;

      case 3:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ProfilePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child; // No transition animation
            },
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_outlined),
          activeIcon: Icon(Icons.qr_code_scanner),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_filter_outlined),
          activeIcon: Icon(Icons.movie_filter),
          label: 'Streaming',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_outlined),
          activeIcon: Icon(Icons.shopping_basket),
          label: 'Shopping',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          activeIcon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      unselectedItemColor: Colors.blueGrey,
      unselectedLabelStyle: const TextStyle(color: Colors.blueGrey),
      unselectedIconTheme: const IconThemeData(color: Colors.blueGrey),
      showUnselectedLabels: true,
      // fixedColor is both of selectedItemColor, selectedIconTheme
      fixedColor: [
        Colors.amber,
        Colors.red,
        Colors.teal.shade300,
        Colors.deepPurpleAccent
      ][_currentIndex],
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      onTap: _onTap,
    );
  }
}
