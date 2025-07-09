import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FacebookImagePreviewController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();

  Rx<TextEditingController?> textController = Rx<TextEditingController?>(null);
  RxBool showTextOverlay = false.obs;

  RxBool showColorPicker = false.obs;
  Rx<Color> overlayBackgroundColor = Colors.black45.obs;

  Future<void> pickImageFromGallery() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      showTextOverlay.value = false;
      textController.value = null;
      showColorPicker.value = false;
      overlayBackgroundColor.value = Colors.black45;
    }
  }

  void addTextOverlay() {
    textController.value = TextEditingController();
    showTextOverlay.value = true;
    showColorPicker.value = false;
    overlayBackgroundColor.value = Colors.black45;
  }

  void toggleColorPicker() {
    showColorPicker.value = !showColorPicker.value;
  }

  void changeOverlayBackgroundColor(Color color) {
    overlayBackgroundColor.value = color;
  }
}
