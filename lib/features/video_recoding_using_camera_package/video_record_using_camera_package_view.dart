import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/reals/video_preview_view.dart';
import 'package:reel_section/features/video_recoding_using_camera_package/video_record_using_camera_package_controller.dart';
import 'package:reel_section/helper/config/color.dart'; // Make sure this file has AppColor defined

class VideoRecorderPage extends StatefulWidget {
  const VideoRecorderPage({super.key});

  @override
  State<VideoRecorderPage> createState() => _RecordVideoViewState();
}

class _RecordVideoViewState extends State<VideoRecorderPage> {
  final videoRecordController = Get.put(
    VideoRecordingControllerUsingCameraPackage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_videoPreviewSection(), _uiOverlay()]),
    );
  }

  Widget _videoPreviewSection() {
    return Obx(() {
      if (!videoRecordController.isInitialized.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return CameraPreview(videoRecordController.cameraController);
    });
  }

  Widget _uiOverlay() {
    return SafeArea(
      child: Stack(
        children: [
          _sideActionBarSection(),
          _selectVideoDurationSection(),
          _videoStartAndStopButtonSection(),
        ],
      ),
    );
  }

  Widget _sideActionBarSection() {
    return Positioned(
      top: 10,
      right: 10,
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: _circleIcon(Icons.close, AppColor.appBackground),
          ),
          const SizedBox(height: 15),
          _circleIcon(Icons.flash_on, AppColor.blue),
          const SizedBox(height: 15),
          InkWell(
            onTap: videoRecordController.switchCamera,
            child: _circleIcon(Icons.cameraswitch, AppColor.blue),
          ),
          const SizedBox(height: 15),
          _circleIcon(Icons.music_note, AppColor.blue),
          const SizedBox(height: 15),
          _circleIcon(Icons.auto_awesome, AppColor.blue),
          const SizedBox(height: 15),
          _circleIcon(Icons.text_fields, AppColor.blue),
        ],
      ),
    );
  }

  Widget _selectVideoDurationSection() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [5, 10, 15, 20].map((time) {
            final isSelected =
                time == videoRecordController.selectedDuration.value;
            return GestureDetector(
              onTap: () {
                if (!videoRecordController.isRecording.value) {
                  videoRecordController.selectedDuration.value = time;
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.blue : AppColor.appBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$time sec",
                  style: TextStyle(color: AppColor.white),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _videoStartAndStopButtonSection() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: Obx(() {
          return GestureDetector(
            onTap: () {
              final duration = videoRecordController.selectedDuration.value;
              if (duration == 0 || videoRecordController.isRecording.value) {
                return;
              }

              videoRecordController.startRecordingForDuration(
                duration,
                (filePath) => Get.to(VideoPreviewView(videoUrl: filePath)),
              );
            },
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: videoRecordController.isRecording.value
                    ? AppColor.red
                    : AppColor.blue,
                border: Border.all(color: Colors.white, width: 4),
                shape: BoxShape.circle,
              ),
              child: videoRecordController.remainingSeconds.value > 0
                  ? Center(
                      child: Text(
                        "00:${videoRecordController.remainingSeconds.value.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _circleIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: AppColor.white, size: 20),
    );
  }
}
