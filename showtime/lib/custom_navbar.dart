import 'package:flutter/material.dart';

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

  final Color? _selectedColor = Colors.teal as Color?;
  final Color? _bgColor = Colors.white as Color?;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // return ClipRRect(
    //   borderRadius: const BorderRadius.all(
    //     Radius.circular(50),
    //   ),
    //   child: BottomNavigationBar(
    //     backgroundColor: Colors.transparent,
    //     // Set the background color of the BottomNavigationBar
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.qr_code_scanner),
    //         label: 'Streaming',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.shopping_basket),
    //         label: 'Shopping',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.account_circle),
    //         label: 'Profile',
    //       ),
    //     ],
    //     currentIndex: _currentIndex,
    //     selectedItemColor: Colors.teal,
    //     onTap: (index) {
    //       setState(() {
    //         _currentIndex = index;
    //       });
    //       if (widget.onItemSelected != null) {
    //         widget.onItemSelected!(index);
    //       }
    //     },
    //   ),
    // );
    return BottomNavigationBar(
      backgroundColor: Colors.white70,
      // Set the background color of the BottomNavigationBar
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
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
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(index);
        }
      },
    );
  }
}
