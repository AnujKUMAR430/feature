//  * Flutter Imports * //
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_section/features/crop_image/pick_image_from_gallery.dart';
import 'package:reel_section/features/map/map_view.dart';
import 'package:reel_section/features/osm_map/osm_map_view.dart';
import 'package:reel_section/features/post/image_post/image_post_view.dart';
import 'package:reel_section/features/post/text_post/text_post_view.dart';
import 'package:reel_section/features/shorts_video_player.dart/short_video_player_view.dart';
import 'package:reel_section/features/video_player/video_player_controller.dart';
import 'package:reel_section/features/video_player/video_player_view.dart';
import 'package:reel_section/features/video_recoding_using_camera_package/video_record_using_camera_package_view.dart';
import 'package:reel_section/helper/extension.dart';
import 'package:reel_section/routes/routes.dart';

class SplashView extends StatefulWidget {
  //  * Parameters * //

  //  * Constructor * //
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  //  * Variables * //

  //  * Functions * //

  //  * Overrides * //

  @override
  void initState() {
    super.initState();
  }

  //  * Build * //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Text(
                "Which Fetaure U Wnat to check !",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              // Native

              // _commonButton(
              //   title: "Record video",
              //   onPressed: () => Get.toNamed(AppRoutes.recordVideoRoute),
              // ),

              // using camrea package
              _commonButton(
                title: "Record video ",
                onPressed: () => Get.to(VideoRecorderPage()),
              ),

              _commonButton(
                title: "Video Player Like Youtube",
                onPressed: () => Get.to(
                  YoutubeStyleVideoPlayer(
                    videoUrl:
                        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                  ),
                ),
              ),
              _commonButton(
                title: "Video Player Like Youtube Shorts",
                onPressed: () => Get.to(
                  ShortsVideoPlayerView(
                    videoUrl:
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  ),
                ),
              ),
              _commonButton(
                title: "Crop image",
                onPressed: () => Get.to(ImageCropExample()),
              ),
              _commonButton(
                title: "Text Post",
                onPressed: () => Get.to(ThoughtPostPage()),
              ),
              _commonButton(
                title: "Image Post",
                onPressed: () => Get.to(FacebookImagePreviewPage()),
              ),
              _commonButton(
                title: "Map",
                onPressed: () => Get.to(OSMCurrentLocationPage()),
              ),
            ].separatedBy(SizedBox(height: 10)),
          ),
        ),
      ),
    );
  }

  //....
  ///
  /// ** Custom Widgets **
  ///
  //....

  Widget _commonButton({
    required String title,
    required void Function()? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}
