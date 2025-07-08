import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThoughtController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final List<Color> backgroundColors = Colors.primaries;
  final List<Color> textColors = [
    Colors.white,
    Colors.black,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

  Rx<Color> backgroundColor = Colors.deepPurple.obs;
  Rx<Color> textColor = Colors.white.obs;

  void setBackgroundColor(Color color) {
    backgroundColor.value = color;
  }

  void setTextColor(Color color) {
    textColor.value = color;
  }

  void pickColor({
    required List<Color> options,
    required Color selectedColor,
    required Function(Color) onColorSelected,
    required String title,
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: options.map((color) {
                  final isSelected = color == selectedColor;
                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      onColorSelected(color);
                    },
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
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
