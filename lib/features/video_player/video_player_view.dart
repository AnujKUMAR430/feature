import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/video_player/video_player_controller.dart';
import 'package:video_player/video_player.dart';

class YoutubeStyleVideoPlayer extends StatelessWidget {
  final String videoUrl;

  const YoutubeStyleVideoPlayer({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(YoutubeStyleVideoPlayerController());
    controller.initialize(videoUrl);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GetBuilder<YoutubeStyleVideoPlayerController>(
          builder: (_) {
            if (!controller.videoController.value.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: AspectRatio(
                aspectRatio: controller.videoController.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoPlayer(controller.videoController),
                    _buildControls(controller),
                    _buildDoubleTapZones(controller),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls(YoutubeStyleVideoPlayerController controller) {
    return Obx(() {
      if (!controller.showControls.value) return const SizedBox.shrink();

      return Positioned.fill(
        child: GestureDetector(
          onTap: controller.togglePlayPause,
          child: Container(
            color: Colors.black45,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    controller.videoController.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VideoProgressIndicator(
                        controller.videoController,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.black26,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              controller.formatDuration(
                                controller.videoController.value.position,
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: controller.toggleFullscreen,
                            icon: Obx(
                              () => Icon(
                                controller.isFullscreen.value
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDoubleTapZones(YoutubeStyleVideoPlayerController controller) {
    return Obx(() {
      return IgnorePointer(
        ignoring: controller.showControls.value,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onDoubleTap: controller.seekBackward,
                onTap: controller.toggleControls,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onDoubleTap: controller.seekForward,
                onTap: controller.toggleControls,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      );
    });
  }
}
