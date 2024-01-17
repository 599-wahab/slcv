import 'package:flutter/material.dart';

class Camera {
  final String name;

  Camera(this.name);
}

class CameraProvider extends ChangeNotifier {
  List<Camera> _cameras = [];

  List<Camera> get cameras => _cameras;

  void addCamera(Camera camera) {
    _cameras.add(camera);
    notifyListeners();
  }
}
