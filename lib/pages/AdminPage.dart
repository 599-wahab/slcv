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
              setState(() {
                isAdminAuthenticated = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Column - Cameras
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: isAdminAuthenticated
                  ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CameraColumn(cameras: [],),
                ),
              )
                  : const Center(
                child: Text(
                  'Admin not authenticated',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Right Column - Logs/Entries
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedPositioned(
                      duration: const Duration(seconds: 1),
                      right: isEntriesVisible ? 0 : -MediaQuery.of(context).size.width * 0.7,
                      child: GestureDetector(
                        onTap: _resetVisibilityTimer,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          color: Colors.blue[500],
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Entries',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Content for the top 80% goes here

                                // Spacer to push the Authorized/Unauthorized to the bottom
                                const Spacer(),

                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Authorized ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 10,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Unauthorized ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 10,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
