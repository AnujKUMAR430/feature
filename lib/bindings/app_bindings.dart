import 'package:get/get.dart';
import 'package:reel_section/features/reals/record_video_and_preview_controller.dart';

class AppBindings extends Bindings {
  //  * Variables * //

  /// * Constructors * ///
  AppBindings();

  @override
  void dependencies() {
    Get.put(VideoRecordAndPreviewController(), permanent: true);
  }

  //  * Functions * //
}
