import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageProvider with ChangeNotifier {
  File? selectedImage;

  getImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 100,
      maxWidth: 100,
    );
    if (pickedImage == null) {
      notifyListeners();
      return null;
    }
    selectedImage = File(pickedImage.path);
    notifyListeners();
  }
}
