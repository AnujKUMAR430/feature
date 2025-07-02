import 'package:get/get.dart';
import 'package:reel_section/features/reals/record_video_view.dart';
import 'package:reel_section/features/reals/video_preview_view.dart';
import 'package:reel_section/views/splash_view.dart';

class AppRoutes {
  //  * Variables * //
  static const String initialRoute = '/';
  static const String recordVideoRoute = '/recordVideo';
  static const String videoPreviewRoute = '/videoPreview';

  /// * Constructors * ///
  AppRoutes();

  //  * Functions * //
  List<GetPage<dynamic>>? getPages() {
    return [
      GetPage(name: initialRoute, page: () => const SplashView()),
      GetPage(name: recordVideoRoute, page: () => const RecordVideoView()),
      GetPage(name: videoPreviewRoute, page: () => const VideoPreviewView()),
    ];
  }
}
