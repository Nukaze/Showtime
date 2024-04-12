import 'package:flutter/material.dart';
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
    if (newIndex == 1 && (Global().videoId == null || Global().videoId!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          dismissDirection: DismissDirection.vertical,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: const Text('Video id not available. \nPlease scan a QR code before using this menu.'),
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
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/QrScanner');
        break;
      case 1:
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StreamingContent(videoId: Global().videoId!),
          ),
        );
        break;
      case 2:
        alertDialog(
          context,
          'Shopping',
          'This feature is not yet implemented.',
        );
        return;
        Navigator.pushReplacementNamed(context, '/Shopping');
        break;
      case 3:
        alertDialog(
          context,
          'Profile',
          'This feature is not yet implemented.',
        );
        return;
        Navigator.pushReplacementNamed(context, '/Profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_filter),
          label: 'Streaming',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Shopping',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.red,
      backgroundColor: Colors.deepPurple,
      onTap: _onTap,
    );
  }
}
