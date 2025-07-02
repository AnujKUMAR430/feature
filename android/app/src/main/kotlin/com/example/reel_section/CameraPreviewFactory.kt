package com.example.reel_section

import android.content.Context
import android.view.SurfaceHolder
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class CameraPreviewFactory(private val onSurfaceCreated: (SurfaceHolder, CameraPreview) -> Unit) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val cameraPreview = CameraPreview(context!!)
        cameraPreview.holder.addCallback(object : SurfaceHolder.Callback {
            override fun surfaceCreated(holder: SurfaceHolder) {
                onSurfaceCreated(holder, cameraPreview)
            }
            override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {}
            override fun surfaceDestroyed(holder: SurfaceHolder) {}
        })
        return cameraPreview
    }
}
