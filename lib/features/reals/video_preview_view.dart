import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/reals/record_video_and_preview_controller.dart';
import 'package:reel_section/helper/config/color.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewView extends StatefulWidget {
  final String videoUrl;

  const VideoPreviewView({super.key, required this.videoUrl});

  @override
  State<VideoPreviewView> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewView> {
  final videoPreviewController = Get.find<VideoRecordAndPreviewController>();

  @override
  void initState() {
    videoPreviewController.init(widget.videoUrl);
    super.initState();
  }

  @override
  void dispose() {
    videoPreviewController.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },

          child: Icon(Icons.arrow_back_ios, color: AppColor.white, size: 16),
        ),
        title: const Text(
          "Video Preview",
          style: TextStyle(color: AppColor.white, fontSize: 16),
        ),
        backgroundColor: AppColor.appBackground,
      ),
      body: Obx(() {
        videoPreviewController.isInitialized.value;
        return videoPreviewController.isInitialized.value
            ? Stack(
                children: [_videoPreviewSection(), _continueButtonSection()],
              )
            : Center(child: const CircularProgressIndicator());
      }),
    );
  }

  Widget _continueButtonSection() {
    return Positioned(
      bottom: 41,
      left: 16,
      right: 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          videoPreviewController.controller.value.isPlaying
              ? videoPreviewController.controller.pause()
              : videoPreviewController.controller.play();
        },
        child: Text("Continue", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _videoPreviewSection() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: videoPreviewController.controller.value.size.width,
          height: videoPreviewController.controller.value.size.height,
          child: VideoPlayer(videoPreviewController.controller),
        ),
      ),
    );
  }
}
