import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'text_post_controller.dart';
import 'text_post_preview.dart';

class ThoughtPostPage extends StatelessWidget {
  ThoughtPostPage({super.key});

  final ThoughtController controller = Get.put(ThoughtController());

  void _openPreview() {
    Get.to(
      () => ThoughtPreviewScreen(
        text: controller.textController.text,
        textColor: Colors.white,
        backgroundColor: controller.backgroundColor.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.backgroundColor.value,
        resizeToAvoidBottomInset: true,
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
        body: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: controller.textController,
                            maxLines: null,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your thought...",
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              color: Colors.black.withOpacity(0.2),
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.backgroundColors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final color = controller.backgroundColors[index];
                    final isSelected =
                        controller.backgroundColor.value == color;

                    return GestureDetector(
                      onTap: () => controller.setBackgroundColor(color),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
