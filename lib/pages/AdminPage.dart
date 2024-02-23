import 'dart:async';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'CameraColumn.dart';
import 'HomeScreen.dart'; // Import HomeScreen
import 'User_Registration.dart'; // Import RegistrationScreen

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isAdminAuthenticated = true;
  bool isEntriesVisible = true;

  late Timer _timer; // Remove the timer

  bool isHomeScreenVisible = false;

  @override
  void initState() {
    super.initState();
    // Remove the timer initialization
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
        child: Stack(
          children: [
            Visibility(
              visible: !isHomeScreenVisible,
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
                        hintText: 'Add camera',
                        suffixIcon: Icon(Icons.add_a_photo_outlined),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isHomeScreenVisible = true;
                          });
                        },
                        icon: const Icon(Icons.image_search, color: Colors.blue),
                        label: const Text('Search by Image',style: TextStyle(color: Colors.blue),),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48), // Set minimum size
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.face, color: Colors.blue),
                        label: const Text('Register',style: TextStyle(color: Colors.blue),),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48), // Set minimum size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isHomeScreenVisible,
              child: HomeScreen(
                onClose: () {
                  setState(() {
                    isHomeScreenVisible = false;
                  });
                },
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
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logoutAndNavigateToLogin();
              },
              child: const Text('Logout'),
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
    // Remove the timer cancellation
    super.dispose();
  }
}
