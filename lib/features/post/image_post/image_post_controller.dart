import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class FacebookImagePreviewController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();

  Rx<TextEditingController?> textController = Rx<TextEditingController?>(null);
  RxBool showTextOverlay = false.obs;

  RxBool showColorPicker = false.obs;
  Rx<Color> overlayBackgroundColor = Colors.black45.obs;

  // 🆕 For drag, scale, rotate
  Rx<Offset> overlayPosition = Offset(0, 0).obs;
  RxDouble overlayScale = 1.0.obs;
  RxDouble overlayRotation = 0.0.obs;
  RxDouble initialRotation = 0.0.obs;

  Future<void> pickImageFromGallery() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      showTextOverlay.value = false;
      textController.value = null;
      showColorPicker.value = false;
      overlayBackgroundColor.value = Colors.black45;
      overlayPosition.value = Offset(0, 0);
      overlayScale.value = 1.0;
      overlayRotation.value = 0.0;
    }
  }

  void addTextOverlay(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerOffset = Offset(
      screenSize.width / 2 - 165,
      screenSize.height / 2 - 100,
    ); // approx center for text box

    textController.value = TextEditingController();
    showTextOverlay.value = true;
    showColorPicker.value = false;
    overlayBackgroundColor.value = Colors.black45;
    overlayPosition.value = centerOffset;
    overlayScale.value = 1.0;
    overlayRotation.value = 0.0;
  }

  void toggleColorPicker() {
    showColorPicker.value = !showColorPicker.value;
  }

  void changeOverlayBackgroundColor(Color color) {
    overlayBackgroundColor.value = color;
  }
}
