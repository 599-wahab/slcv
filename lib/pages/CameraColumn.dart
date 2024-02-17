import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera Display'),
        ),
        body: cameras.isNotEmpty ? CameraColumn(cameras: cameras) : const NoCameraAvailable(),
      ),
    );
  }
}

class CameraColumn extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraColumn({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraColumnState createState() => _CameraColumnState();
}

class _CameraColumnState extends State<CameraColumn> {
  late CameraController? _controller; // Make _controller nullable

  List<String> cameraNames = ['Default Camera']; // Initialize with default camera

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      _initCamera(widget.cameras.first); // Initialize with the first available camera
    }
  }

  Future<void> _initCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    await _controller!.initialize();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose only if initialized
    super.dispose();
  }

  Widget buildFittedCameraContainer(String cameraName) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            // Conditional rendering of camera preview or loading indicator
            _controller != null && _controller!.value.isInitialized // Check if _controller is not null
                ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            )
                : const CircularProgressIndicator(), // Show loading indicator while camera is initializing
            const SizedBox(height: 8),
            Text('Camera: $cameraName'),
          ],
        ),
      ),
    );
  }

  Widget buildPlusIconContainer() {
    return GestureDetector(
      onTap: () {
        // Add a new camera when the plus icon is pressed
        setState(() {
          final newIndex = cameraNames.length;
          final newCameraDescription = widget.cameras[newIndex % widget.cameras.length];
          cameraNames.add('New Camera ${newIndex + 1}');
          _initCamera(newCameraDescription);
        });
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Add Camera'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cameras',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of Camera Containers
                ...cameraNames.map((cameraName) => buildFittedCameraContainer(cameraName)).toList(),
                // Plus Icon Container
                buildPlusIconContainer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NoCameraAvailable extends StatelessWidget {
  const NoCameraAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No cameras available',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
