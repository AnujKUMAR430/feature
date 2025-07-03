import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRecordingControllerUsingCameraPackage extends GetxController {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  var isInitialized = false.obs;
  var isRecording = false.obs;
  var selectedCameraIndex = 0.obs;

  var selectedDuration = 0.obs;

  RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  void startCountdown(int seconds) {
    remainingSeconds.value = seconds;

    _timer?.cancel(); // cancel existing timer if any
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  Future<void> initCamera() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    cameras = await availableCameras();
    await _initializeCamera(cameras[selectedCameraIndex.value]);
  }

  Future<void> _initializeCamera(CameraDescription description) async {
    isInitialized.value = false;

    cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await cameraController.initialize();

    isInitialized.value = true;
  }

  void switchCamera() async {
    isInitialized.value = false;

    selectedCameraIndex.value =
        (selectedCameraIndex.value + 1) % cameras.length;

    await cameraController.dispose();
    await Future.delayed(const Duration(milliseconds: 200));

    await _initializeCamera(cameras[selectedCameraIndex.value]);
  }

  Future<void> startRecordingForDuration(
    int seconds,
    void Function(String path) onComplete,
  ) async {
    if (!cameraController.value.isInitialized || isRecording.value) return;

    await cameraController.startVideoRecording();
    startCountdown(seconds);
    isRecording.value = true;

    Timer(Duration(seconds: seconds), () async {
      if (cameraController.value.isRecordingVideo) {
        final file = await cameraController.stopVideoRecording();
        isRecording.value = false;
        onComplete(file.path);
      }
    });
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
