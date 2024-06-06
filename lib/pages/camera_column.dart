import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'package:path_provider/path_provider.dart';

class CameraColumn extends StatefulWidget {
  final bool isEntriesVisible;

  const CameraColumn({super.key, required this.isEntriesVisible});

  @override
  _CameraColumnState createState() => _CameraColumnState();
}

class _CameraColumnState extends State<CameraColumn> with WidgetsBindingObserver {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isModelLoaded = false;
  Map<String, dynamic> _facesData = {};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    loadModel();
    _loadSavedFaces();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_isCameraInitialized) {
      if (state == AppLifecycleState.paused) {
        _cameraController.dispose();
      } else if (state == AppLifecycleState.resumed) {
        _initializeCamera();
      }
    }
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    final bool cameraPermissionGranted = await _requestCameraPermission();
    if (!cameraPermissionGranted) {
      return;
    }

    try {
      final cameras = await availableCameras();
      _cameras = cameras;
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(_cameras.first, ResolutionPreset.high);
        await _cameraController.initialize();
        _isCameraInitialized = true;
      } else {
        print('No cameras available');
      }
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      PermissionStatus cameraPermissionStatus = await Permission.camera.request();
      if (cameraPermissionStatus != PermissionStatus.granted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Camera Permission Required'),
              content: const Text('Please grant camera permission to use the camera.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }
    }
    return true;
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/mobilefacenet.tflite",
      // Remove the labels parameter
    );
    _isModelLoaded = true;
  }

  Future<void> _loadSavedFaces() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${appDocDir.path}/savedFaces.json');
    if (jsonFile.existsSync()) {
      setState(() {
        _facesData = json.decode(jsonFile.readAsStringSync());
      });
    }
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _cameraController.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _runModelOnFrame(CameraImage cameraImage) async {
    if (_isModelLoaded) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
      );
      print(recognitions);
      // Process the recognitions here
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEntriesVisible
        ? _isCameraInitialized && _isModelLoaded
        ? LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > constraints.maxHeight) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: CameraPreview(_cameraController),
        );
      } else {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: const Text('Please turn your device to landscape mode.'),
        );
      }
    })
        : const Center(child: CircularProgressIndicator())
        : Container();
  }
}
