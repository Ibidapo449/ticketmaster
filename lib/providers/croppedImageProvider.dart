import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CroppedImageProvider extends ChangeNotifier {
  File? _image;
  File? get image => _image;

  CroppedImageProvider() {
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('selectedImagePath');
    if (path != null && File(path).existsSync()) {
      _image = File(path);
      notifyListeners();
    }
  }

  Future<void> setImage(File? img) async {
    _image = img;
    final prefs = await SharedPreferences.getInstance();
    if (img != null) {
      await prefs.setString('selectedImagePath', img.path);
    } else {
      await prefs.remove('selectedImagePath');
    }
    // _loadSavedImage();
    notifyListeners();
  }
}
