import 'package:flutter/material.dart';

class CameraColumn extends StatefulWidget {
  const CameraColumn({Key? key}) : super(key: key);

  @override
  _CameraColumnState createState() => _CameraColumnState();
}

class _CameraColumnState extends State<CameraColumn> {
  List<String> cameras = []; // List to store camera data

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
                ...cameras.map((camera) => buildFittedCameraContainer(camera)).toList(),
                // Plus Icon Container
                buildPlusIconContainer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFittedCameraContainer(String camera) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            // Display camera details (you can customize this based on your camera data)
            Text('Camera: $camera'),
            // Add more camera details or widgets as needed
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
          cameras.add('New Camera ${cameras.length + 1}');
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
}
