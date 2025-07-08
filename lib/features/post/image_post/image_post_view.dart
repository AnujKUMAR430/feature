import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:reel_section/features/post/image_post/image_post_controller.dart';
import 'package:reel_section/features/post/image_post/image_post_preview.dart';

class ImageTextEditor extends StatelessWidget {
  ImageTextEditor({super.key});
  final controller = Get.put(TextEditorController());

  void openTextEditor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.textController,
                decoration: const InputDecoration(labelText: 'Enter Text'),
                onChanged: controller.updateText,
              ),
              const SizedBox(height: 10),
              Row(
                children: [const Text("Text Color: "), ...buildColorOptions()],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Font Size: "),
                  Expanded(
                    child: Slider(
                      value: controller.fontSize.value,
                      min: 10,
                      max: 80,
                      onChanged: controller.updateFontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildColorOptions() {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    return colors
        .map(
          (color) => Obx(
            () => GestureDetector(
              onTap: () => controller.updateColor(color),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.textColor.value == color
                        ? Colors.grey
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  void goToPreviewScreen(BuildContext context) {
    if (controller.image.value != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            image: controller.image.value!,
            text: controller.text.value,
            textColor: controller.textColor.value,
            fontSize: controller.fontSize.value,
            textPosition: controller.textPosition.value,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Text Editor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => openTextEditor(context),
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () => goToPreviewScreen(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.pickImage,
        child: const Icon(Icons.image),
      ),
      body: Obx(() {
        final image = controller.image.value;
        final text = controller.text.value;
        final position = controller.textPosition.value;
        final fontSize = controller.fontSize.value;
        final color = controller.textColor.value;

        return image == null
            ? const Center(child: Text("Pick an image"))
            : Stack(
                children: [
                  Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
                  Positioned.fill(
                    child: GestureDetector(
                      onPanUpdate: (details) =>
                          controller.updatePosition(details.delta),
                      child: Stack(
                        children: [
                          if (text.isNotEmpty)
                            Positioned(
                              left: position.dx,
                              top: position.dy,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width -
                                      position.dx -
                                      20,
                                ),
                                child: Text(
                                  text,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
