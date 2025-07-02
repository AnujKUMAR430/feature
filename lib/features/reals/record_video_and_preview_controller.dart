import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reel_section/routes/routes.dart';
import 'package:video_player/video_player.dart';

class VideoRecordAndPreviewController extends GetxController {
  // video Record Section =========
  RxInt selectedTime = 5.obs;
  final List<int> durations = [5, 10, 15, 20];
  Timer? recordingTimer;

  static const platform = MethodChannel('com.example.reel_section/record');
  RxBool isRecording = false.obs;
  RxString videoPath = "".obs;

  RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  void startCountdown(int seconds) {
    remainingSeconds.value = seconds;

    _timer?.cancel(); // cancel existing timer if any
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  Future<void> startRecording() async {
    if (await _requestPermissions()) {
      final path = await platform.invokeMethod<String>('startRecording');
      isRecording.value = true;
      videoPath.value = path ?? "";
      startCountdown(selectedTime.value);

      recordingTimer = Timer(Duration(seconds: selectedTime.value), () async {
        await stopRecording(); // Stop recording after duration

        debugPrint('Recording stopped after ${selectedTime.value} seconds');
      });
    } else {
      debugPrint('❌ Permission not granted');
    }
  }

  Future<void> switchCamera() async {
    if (await _requestPermissions()) {
      MethodChannel(
        'com.example.reel_section/record',
      ).invokeMethod('switchCamera');
    }
  }

  Future<void> stopRecording() async {
    final path = await platform.invokeMethod<String>('stopRecording');

    debugPrint('---stopRecording path---->$path');

    isRecording.value = false;
    videoPath.value = "";
    videoPath.value = path ?? "";
    debugPrint('---recoded video path---->$videoPath');
    recordingTimer?.cancel();
    _timer?.cancel();
    remainingSeconds.value = 0;
    if (videoPath.value.isNotEmpty) {
      Get.toNamed(AppRoutes.videoPreviewRoute);
    }
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    return statuses.values.every((status) => status.isGranted);
  }

  // =========== Video Preview Section

  late VideoPlayerController controller;
  RxBool isInitialized = false.obs;

  void init() {
    isInitialized.value = false;
    controller = VideoPlayerController.file(File(videoPath.value))
      ..initialize().then((_) {
        isInitialized.value = true;
        controller.play();
      });
  }
}
