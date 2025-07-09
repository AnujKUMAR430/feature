import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThoughtController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final List<Color> backgroundColors = Colors.primaries;
  Rx<Color> backgroundColor = Colors.deepPurple.obs;

  void setBackgroundColor(Color color) {
    backgroundColor.value = color;
  }
}
