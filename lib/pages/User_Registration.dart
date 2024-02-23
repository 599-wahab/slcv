import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {
  late ImagePicker imagePicker;
  File? _image;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController CNICController = TextEditingController();
  TextEditingController RegistrationNumberController = TextEditingController();
  TextEditingController LabeController = TextEditingController();

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

  void register() {
    // Implement registration logic here
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Registration'),
        content: const Text('Are you sure you want to cancel the registration?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _image != null
                  ? Container(
                margin: EdgeInsets.only(top: screenHeight * 0.1),
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                child: Image.file(_image!),
              )
                  : Container(
                child: Image.asset(
                  "images/logo.png",
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _imgFromGallery,
                      icon: const Icon(Icons.image, color: Colors.blue),
                      label: const Text(
                        'Gallery',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _imgFromCamera,
                      icon: const Icon(Icons.camera, color: Colors.blue),
                      label: const Text(
                        'Camera',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        // Update LabelController value
                        LabeController.text = value.split(" ")[0];
                      },
                    ),
                    TextField(
                      controller: CNICController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'CNIC',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                    ),
                    TextField(
                      controller: RegistrationNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Registration Number',
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                    ),
                    TextField(
                      controller: LabeController,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'Label (Auto-filled)',
                        prefixIcon: Icon(Icons.label),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: register,
                      icon: const Icon(Icons.app_registration, color: Colors.blue),
                      label: const Text(
                        'Register',
                        style: TextStyle(color: Colors.blue),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
