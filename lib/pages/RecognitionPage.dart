import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionScreen extends StatefulWidget {
  final VoidCallback onClose;

  const RecognitionScreen({Key? key, required this.onClose}) : super(key: key);

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  late ImagePicker imagePicker;
  File? _image;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  doFaceDetection() {
    // Perform face detection here
  }

  void onCloseScreen() {
    widget.onClose(); // Call the onClose callback to close the screen
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            onCloseScreen(); // Close the RecognitionScreen on left swipe
          }
        },
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Align elements in the center vertically
              children: [
                Container(
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.3,
                  margin: EdgeInsets.only(top: screenHeight * 0.1), // Adjust top margin here
                  child: _image != null
                      ? Image.file(
                    _image!,
                    fit: BoxFit.contain,
                  )
                      : Image.asset(
                    "images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1), // Reduce the space between the image and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _imgFromGallery,
                      icon: const Icon(Icons.image),
                      label: const Text('Gallery'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _imgFromCamera,
                      icon: const Icon(Icons.camera),
                      label: const Text('Camera'),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only (top: 170),
                  child: Text('Swipe left to close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
