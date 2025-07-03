// shorts_video_player.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/shorts_video_player.dart/short_video_player_controller.dart';
import 'package:video_player/video_player.dart';

class ShortsVideoPlayerView extends StatelessWidget {
  final String videoUrl;

  const ShortsVideoPlayerView({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShotsVideoController(videoUrl));

    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<ShotsVideoController>(
        builder: (_) {
          if (!controller.videoPlayerController.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return GestureDetector(
            onTap: controller.togglePlayPause,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.videoPlayerController.value.size.width,
                      height:
                          controller.videoPlayerController.value.size.height,
                      child: VideoPlayer(controller.videoPlayerController),
                    ),
                  ),
                ),
                VideoProgressIndicator(
                  controller.videoPlayerController,
                  allowScrubbing: false,
                  padding: const EdgeInsets.only(bottom: 24),
                  colors: VideoProgressColors(
                    playedColor: Colors.red,
                    backgroundColor: Colors.white24,
                    bufferedColor: Colors.grey,
                  ),
                ),
                Obx(
                  () => controller.isPlaying.value
                      ? const SizedBox()
                      : const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
