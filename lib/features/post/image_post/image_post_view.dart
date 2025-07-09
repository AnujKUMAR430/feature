import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/post/image_post/image_post_controller.dart';

class FacebookImagePreviewPage extends StatelessWidget {
  final FacebookImagePreviewController controller = Get.put(
    FacebookImagePreviewController(),
  );

  final List<Color> bgColors = [
    Colors.black45,
    Colors.white70,
    Colors.red.withOpacity(0.6),
    Colors.blue.withOpacity(0.6),
    Colors.green.withOpacity(0.6),
    Colors.purple.withOpacity(0.6),
    Colors.orange.withOpacity(0.6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Image Preview"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: controller.pickImageFromGallery,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.addTextOverlay,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: controller.toggleColorPicker,
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(() {
          final image = controller.selectedImage.value;
          final textCtrl = controller.textController.value;

          if (image == null) {
            return const Center(
              child: Text(
                "Tap the gallery icon to select an image",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return Stack(
            children: [
              // ✅ Background image
              Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),

              // ✅ Text overlay with gesture support
              if (controller.showTextOverlay.value && textCtrl != null)
                Positioned.fill(
                  child: GestureDetector(
                    onScaleStart: (details) {
                      controller.initialRotation.value =
                          controller.overlayRotation.value;
                    },

                    onScaleUpdate: (details) {
                      controller.overlayPosition.value +=
                          details.focalPointDelta;

                      // Clamp scale
                      controller.overlayScale.value =
                          (controller.overlayScale.value * details.scale).clamp(
                            0.5,
                            5.0,
                          );

                      // Apply rotation relative to starting point
                      controller.overlayRotation.value =
                          controller.initialRotation.value + details.rotation;
                    },

                    child: Obx(
                      () => Stack(
                        children: [
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
                                    color:
                                        controller.overlayBackgroundColor.value,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 100,
                                      maxWidth:
                                          300, // ✅ FIX for InputDecorator error
                                    ),
                                    child: TextField(
                                      controller: textCtrl,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        hintText: "Type here...",
                                        hintStyle: TextStyle(
                                          color: Colors.white38,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ✅ Color Picker
              if (controller.showColorPicker.value)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.black.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: bgColors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final color = bgColors[index];
                        return GestureDetector(
                          onTap: () =>
                              controller.changeOverlayBackgroundColor(color),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
