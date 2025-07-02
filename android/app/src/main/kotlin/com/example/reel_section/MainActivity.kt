package com.example.reel_section

import android.Manifest
import android.content.pm.PackageManager
import android.hardware.Camera
import android.media.MediaRecorder
import android.os.Bundle
import android.view.Surface
import android.view.SurfaceHolder
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.reel_section/record"

    private var camera: Camera? = null
    private var recorder: MediaRecorder? = null
    private var holder: SurfaceHolder? = null
    private var recordedFilePath: String? = null
    private var currentCameraId = Camera.CameraInfo.CAMERA_FACING_BACK
    private var cameraPreview: CameraPreview? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.platformViewsController.registry.registerViewFactory(
            "native-camera-preview",
            CameraPreviewFactory { surfaceHolder, preview ->
                this.holder = surfaceHolder
                this.cameraPreview = preview
                startCameraPreview()
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startRecording" -> {
                    try {
                        startRecording()
                        result.success("Recording started")
                    } catch (e: Exception) {
                        result.error("error", e.message, null)
                    }
                }
                "stopRecording" -> {
                    stopRecording()
                    result.success(recordedFilePath)
                }
                "switchCamera" -> {
                    try {
                        switchCamera()
                        result.success("Camera switched")
                    } catch (e: Exception) {
                        result.error("error", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startCameraPreview() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            throw RuntimeException("Camera permission not granted")
        }
        if (holder == null) return

        camera?.apply {
            stopPreview()
            release()
        }

        camera = Camera.open(currentCameraId)
        setCameraDisplayOrientation(currentCameraId)

        try {
            camera?.setPreviewDisplay(holder)
            camera?.startPreview()

            // Mirror preview only if front camera
            cameraPreview?.setMirror(currentCameraId == Camera.CameraInfo.CAMERA_FACING_FRONT)

        } catch (e: Exception) {
            e.printStackTrace()
            throw RuntimeException("Failed to start camera preview: ${e.message}")
        }
    }

    private fun startRecording() {
        if (camera == null || holder == null) {
            throw RuntimeException("Camera or surface not ready")
        }

        recordedFilePath = "${externalCacheDir?.absolutePath}/video_${System.currentTimeMillis()}.mp4"

        recorder = MediaRecorder().apply {
            camera?.unlock()
            setCamera(camera)
            setAudioSource(MediaRecorder.AudioSource.CAMCORDER)
            setVideoSource(MediaRecorder.VideoSource.CAMERA)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setOutputFile(recordedFilePath)
            setPreviewDisplay(holder?.surface)

            // Correct orientation for recording
            val orientationHint = calculateVideoOrientationHint(currentCameraId)
            setOrientationHint(orientationHint)

            prepare()
            start()
        }
    }

    private fun stopRecording() {
        try {
            recorder?.apply {
                stop()
                reset()
                release()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        recorder = null

        camera?.apply {
            lock()
            startPreview()
        }
    }

    private fun switchCamera() {
        currentCameraId = if (currentCameraId == Camera.CameraInfo.CAMERA_FACING_BACK)
            Camera.CameraInfo.CAMERA_FACING_FRONT
        else
            Camera.CameraInfo.CAMERA_FACING_BACK

        startCameraPreview()
    }

    private fun setCameraDisplayOrientation(cameraId: Int) {
        val info = Camera.CameraInfo()
        Camera.getCameraInfo(cameraId, info)

        val rotation = windowManager.defaultDisplay.rotation
        val degrees = when (rotation) {
            Surface.ROTATION_0 -> 0
            Surface.ROTATION_90 -> 90
            Surface.ROTATION_180 -> 180
            Surface.ROTATION_270 -> 270
            else -> 0
        }

        val result = if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
            (info.orientation + degrees) % 360
        } else {
            (info.orientation - degrees + 360) % 360
        }

        camera?.setDisplayOrientation(result)
    }

    private fun calculateVideoOrientationHint(cameraId: Int): Int {
        val info = Camera.CameraInfo()
        Camera.getCameraInfo(cameraId, info)

        val rotation = windowManager.defaultDisplay.rotation
        val degrees = when (rotation) {
            Surface.ROTATION_0 -> 0
            Surface.ROTATION_90 -> 90
            Surface.ROTATION_180 -> 180
            Surface.ROTATION_270 -> 270
            else -> 0
        }

        return if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
            (info.orientation - degrees + 360) % 360  // ✅ Fix for upside-down video on front
        } else {
            (info.orientation + degrees) % 360
        }
    }

    override fun onPause() {
        super.onPause()
        recorder?.release()
        camera?.apply {
            stopPreview()
            release()
        }
        recorder = null
        camera = null
    }
}
