// video_controller.dart
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ShotsVideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var isPlaying = false.obs;

  final String url;
  ShotsVideoController(this.url);

  @override
  void onInit() {
    super.onInit();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        videoPlayerController.setLooping(true);
        videoPlayerController.play();
        isPlaying.value = true;
        update();
      });
  }

  void togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController.play();
      isPlaying.value = true;
    }
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
