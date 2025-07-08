import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TextEditorController extends GetxController {
  Rx<File?> image = Rx<File?>(null);
  RxString text = ''.obs;
  Rx<Color> textColor = Colors.white.obs;
  RxDouble fontSize = 24.0.obs;
  Rx<Offset> textPosition = const Offset(100, 100).obs;
  final textController = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) image.value = File(pickedFile.path);
  }

  void updateText(String value) {
    text.value = value;
  }

  void updateFontSize(double size) {
    fontSize.value = size;
  }

  void updateColor(Color color) {
    textColor.value = color;
  }

  void updatePosition(Offset delta) {
    textPosition.value += delta;
  }
}
