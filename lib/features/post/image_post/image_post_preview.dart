import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/post/image_post/image_post_controller.dart';

class FacebookImagePreviewFinalScreen extends StatelessWidget {
  final FacebookImagePreviewController controller =
      Get.find<FacebookImagePreviewController>();

  @override
  Widget build(BuildContext context) {
    final image = controller.selectedImage.value;
    final text = controller.textController.value?.text ?? '';

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview Post"),
        backgroundColor: Colors.black,
      ),
      body: image == null
          ? const Center(
              child: Text(
                "No image selected",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : Stack(
              children: [
                // ✅ Final image
                Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),

                // ✅ Final positioned & styled text
                if (text.isNotEmpty)
                  Positioned(
                    left: controller.overlayPosition.value.dx,
                    top: controller.overlayPosition.value.dy,
                    child: Transform.rotate(
                      angle: controller.overlayRotation.value,
                      child: Transform.scale(
                        scale: controller.overlayScale.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: controller.overlayBackgroundColor.value,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
