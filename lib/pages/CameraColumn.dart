import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraColumn extends StatefulWidget {
  final bool isEntriesVisible;

  const CameraColumn({Key? key, required this.isEntriesVisible}) : super(key: key);

  @override
  _CameraColumnState createState() => _CameraColumnState();
}

class _CameraColumnState extends State<CameraColumn> with WidgetsBindingObserver {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance?.addObserver(this);
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

    // Check camera permissions
    final bool cameraPermissionGranted = await _requestCameraPermission();
    if (!cameraPermissionGranted) {
      return;
    }

    // Check if the camera plugin is available
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
      setState(() {}); // Refresh widget after camera initialization
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Check camera permission for Windows, MacOS, Linux
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

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _cameraController.dispose();
    }
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEntriesVisible
        ? _isCameraInitialized
        ? LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > constraints.maxHeight) {
          // Landscape orientation
          if (constraints.maxWidth > constraints.maxHeight * 2) {
            // Full screen, split into 4 squares
            return _buildGridLayout(2, 2);
          } else {
            // Half screen, split vertically
            return _buildGridLayout(2, 1);
          }
        } else {
          // Portrait orientation, split vertically
          return _buildGridLayout(2, 1);
        }
      },
    )
        : Center(
      child: ElevatedButton(
        onPressed: _initializeCamera,
        child: const Text('Add Camera'),
      ),
    )
        : Container();
  }

  Widget _buildGridLayout(int rowCount, int columnCount) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: rowCount * columnCount,
      itemBuilder: (BuildContext context, int index) {
        if (index < _cameras.length) {
          // Display camera preview in the grid cell if camera available
          return _buildCameraPreview(index);
        } else {
          // Display placeholder with plus sign in other grid cells
          return _buildPlaceholderWithPlusSign();
        }
      },
    );
  }

  Widget _buildCameraPreview(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the padding as needed
      child: AspectRatio(
        aspectRatio: _cameraController.value.aspectRatio,
        child: CameraPreview(_cameraController),
      ),
    );
  }

  Widget _buildPlaceholderWithPlusSign() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.add,
          size: 48.0,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
