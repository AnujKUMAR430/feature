package com.example.reel_section

import android.content.Context
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import io.flutter.plugin.platform.PlatformView

class CameraPreview(context: Context) : PlatformView {
    val surfaceView: SurfaceView = SurfaceView(context)
    val holder: SurfaceHolder = surfaceView.holder

    override fun getView(): View = surfaceView
    override fun dispose() {}

    // Add mirror control
    fun setMirror(isMirror: Boolean) {
        surfaceView.scaleX = if (isMirror) -1f else 1f
    }
}
