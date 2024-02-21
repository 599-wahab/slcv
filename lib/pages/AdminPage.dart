import 'dart:async';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'CameraColumn.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isAdminAuthenticated = true;
  bool isEntriesVisible = true;

  late Timer _timer;
  static const int visibilityDuration = 20; // seconds

  @override
  void initState() {
    super.initState();
    _startVisibilityTimer();
  }

  void _startVisibilityTimer() {
    _timer = Timer.periodic(const Duration(seconds: visibilityDuration), (timer) {
      setState(() {
        isEntriesVisible = false;
      });
    });
  }

  void _resetVisibilityTimer() {
    _timer.cancel();
    setState(() {
      isEntriesVisible = true;
    });
    _startVisibilityTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blue[500],
        elevation: 23,
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Image.asset('lib/assets/main-logo.png'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Image',
                  suffixIcon: Icon(Icons.camera_alt_outlined),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Add camera',
                  suffixIcon: Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CameraColumn(isEntriesVisible: isEntriesVisible),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logoutAndNavigateToLogin();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logoutAndNavigateToLogin() {
    // Turn off camera
    // Example: _cameraController.dispose();

    // Logout
    // Example: Perform logout logic here

    // Navigate to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}