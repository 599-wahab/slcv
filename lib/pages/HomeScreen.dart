import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'RecognitionPage.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final VoidCallback onClose; // Define the onClose callback

  const HomeScreen({Key? key, required this.onClose}) : super(key: key); // Update the constructor

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  bool isRecognitionScreenVisible = false; // Track the visibility of RecognitionScreen

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isMobilePlatform = Platform.isAndroid || Platform.isIOS;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < 0) {
                      widget.onClose(); // Call the onClose callback
                    }
                  },
                  child: Dismissible(
                    key: const Key('home_screen_dismissible'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      widget.onClose(); // Call the onClose callback
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: isMobilePlatform ? screenHeight * 0.1 : screenHeight * 0.05),
                          child: Image.asset(
                            "images/logo.png",
                            width: isMobilePlatform ? screenWidth * 0.8 : 200,
                            height: isMobilePlatform ? screenWidth * 0.8 : 200,
                          ),
                        ),
                        SizedBox(height: isMobilePlatform ? screenHeight * 0.05 : 20),
                        Container(
                          margin: EdgeInsets.only(bottom: isMobilePlatform ? screenHeight * 0.05 : 20),
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isRecognitionScreenVisible = true; // Show RecognitionScreen
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: isMobilePlatform ? Size(screenWidth * 0.8, screenHeight * 0.08) : Size(200, 40),
                                ),
                                child: const Text("Recognize"),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back), // Back arrow icon
                              SizedBox(width: 8), // Spacing
                              Text('Swipe left to close'), // Hint text
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
          if (isRecognitionScreenVisible)
            RecognitionScreen(onClose: () {
              setState(() {
                isRecognitionScreenVisible = false; // Hide RecognitionScreen
              });
            }),
        ],
      ),
    );
  }
}
