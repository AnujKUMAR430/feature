import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/post/text_post/text_post_controller.dart';
import 'package:reel_section/features/post/text_post/text_post_preview.dart';

class ThoughtPostPage extends StatelessWidget {
  ThoughtPostPage({super.key});

  final ThoughtController controller = Get.put(ThoughtController());

  void _openPreview() {
    Get.to(
      () => ThoughtPreviewScreen(
        text: controller.textController.text,
        textColor: controller.textColor.value,
        backgroundColor: controller.backgroundColor.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Obx(
      () => Scaffold(
        backgroundColor: controller.backgroundColor.value,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _openPreview,
              icon: const Icon(Icons.check),
              tooltip: 'Post',
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Center(
                child: TextField(
                  controller: controller.textController,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: controller.textColor.value,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type your thought...",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 32,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    heroTag: "bg",
                    backgroundColor: Colors.white24,
                    onPressed: () {
                      controller.pickColor(
                        options: controller.backgroundColors,
                        selectedColor: controller.backgroundColor.value,
                        onColorSelected: controller.setBackgroundColor,
                        title: "Select Background Color",
                        context: context,
                      );
                    },
                    tooltip: 'Pick Background',
                    child: const Icon(Icons.format_color_fill),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    mini: true,
                    heroTag: "text",
                    backgroundColor: Colors.white24,
                    onPressed: () {
                      controller.pickColor(
                        options: controller.textColors,
                        selectedColor: controller.textColor.value,
                        onColorSelected: controller.setTextColor,
                        title: "Select Text Color",
                        context: context,
                      );
                    },
                    tooltip: 'Pick Text Color',
                    child: const Icon(Icons.text_fields),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
