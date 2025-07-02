import 'package:flutter/material.dart';

//  * Flutter Imports * //
import 'package:get/get.dart';
import 'package:reel_section/features/reals/record_video_and_preview_controller.dart';
import 'package:reel_section/helper/config/color.dart';

//  * Third Party Imports * //

//  * Custom Imports * //

class RecordVideoView extends StatefulWidget {
  //  * Parameters * //

  //  * Constructor * //
  const RecordVideoView({super.key});

  @override
  State<RecordVideoView> createState() => _RecordVideoViewState();
}

class _RecordVideoViewState extends State<RecordVideoView> {
  //  * Variables * //
  final videoRecordController = Get.find<VideoRecordAndPreviewController>();

  //  * Functions * //

  //  * Overrides * //

  //  * Build * //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_videoPreviewSection(), _otherPortion()]),
    );
  }

  Widget _otherPortion() {
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
            onTap: () {
              Get.back();
            },

            child: _circleIcon(Icons.close, AppColor.appBackground),
          ),
          SizedBox(height: 15),
          _circleIcon(Icons.flash_on, AppColor.blue),
          SizedBox(height: 15),
          InkWell(
            onTap: () {
              videoRecordController.switchCamera();
            },

            child: _circleIcon(Icons.camera_alt, AppColor.blue),
          ),
          SizedBox(height: 15),
          _circleIcon(Icons.music_note, AppColor.blue),
          SizedBox(height: 15),
          _circleIcon(Icons.auto_awesome, AppColor.blue),
          SizedBox(height: 15),
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
          children: videoRecordController.durations.map((time) {
            bool isSelected = time == videoRecordController.selectedTime.value;
            return GestureDetector(
              onTap: () {
                videoRecordController.selectedTime.value = time;
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : AppColor.appBackground,
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
            onTap: videoRecordController.isRecording.value
                ? videoRecordController.stopRecording
                : videoRecordController.startRecording,
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
              child: videoRecordController.remainingSeconds.value != 0
                  ? Center(
                      child: Text(
                        "00:${videoRecordController.remainingSeconds.value}",
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

  Widget _videoPreviewSection() {
    return AndroidView(
      viewType: 'native-camera-preview',
      layoutDirection: TextDirection.ltr,
    );
  }

  Widget _circleIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      padding: EdgeInsets.all(10),
      child: Icon(icon, color: AppColor.white, size: 20),
    );
  }

  //....
  ///
  /// * Custom Widgets *
  ///
  //....
}
