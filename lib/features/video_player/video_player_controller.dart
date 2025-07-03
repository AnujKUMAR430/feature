import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class YoutubeStyleVideoPlayerController extends GetxController {
  late VideoPlayerController videoController;
  RxBool showControls = true.obs;
  RxBool isFullscreen = false.obs;
  final Duration skipDuration = const Duration(seconds: 10);
  Timer? _hideTimer;

  // Added
  RxBool showForwardIcon = false.obs;
  RxBool showBackwardIcon = false.obs;

  void initialize(String url) {
    videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        update();
        videoController.play();
        _startHideTimer();
      });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      showControls.value = false;
    });
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value) _startHideTimer();
  }

  void seekForward() {
    final target = videoController.value.position + skipDuration;
    if (target < videoController.value.duration) {
      videoController.seekTo(target);
    } else {
      videoController.seekTo(videoController.value.duration);
    }

    // Show icon
    showForwardIcon.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      showForwardIcon.value = false;
    });

    _startHideTimer();
  }

  void seekBackward() {
    final target = videoController.value.position - skipDuration;
    if (target > Duration.zero) {
      videoController.seekTo(target);
    } else {
      videoController.seekTo(Duration.zero);
    }

    // Show icon
    showBackwardIcon.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      showBackwardIcon.value = false;
    });

    _startHideTimer();
  }

  void togglePlayPause() {
    if (videoController.value.isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
    _startHideTimer();
    update();
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    if (isFullscreen.value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  String formatDuration(Duration position) {
    final minutes = position.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void onClose() {
    videoController.dispose();
    _hideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.onClose();
  }
}
