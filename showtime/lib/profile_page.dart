import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showtime/custom_navbar.dart';
import 'package:showtime/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = 'Blue Sensei';
  String email = 'sensei@bluearchive.com';
  String password = 'password123';
  String telNum = '+1 123 456 7890';
  int yearOfBirth = 1998;

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 3;

  int _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    return _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const usernameColor = Colors.cyan;
    const infoColor = Colors.white70;
    final dimBackgroundColor = Colors.black.withOpacity(0.5);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/showtime_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                color: dimBackgroundColor,
                width: screenWidth * 0.9,
                height: screenHeight * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.15),
                    const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/sensei.png'),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      username,
                      style:
                          const TextStyle(fontSize: 24, color: usernameColor),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      'Year of Birth: $yearOfBirth',
                      style: const TextStyle(color: infoColor),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      email,
                      style: const TextStyle(color: infoColor),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      'Tel. No.: $telNum',
                      style: const TextStyle(color: infoColor),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade500,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // Handle edit password button press
                          },
                          child: const Text('Edit Password'),
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            alertDialog(
                              context,
                              "Alert",
                              "Are you sure you want to logout?",
                              acceptText: "Logout",
                              cancelText: "Cancel",
                              onAccept: () {
                                SystemNavigator.pop();
                              },
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          initialIndex: 3,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
