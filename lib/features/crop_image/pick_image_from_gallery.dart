import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:croppy/croppy.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropExample extends StatefulWidget {
  const ImageCropExample({super.key});

  @override
  State<ImageCropExample> createState() => _ImageCropExampleState();
}

class _ImageCropExampleState extends State<ImageCropExample> {
  final ImagePicker _picker = ImagePicker();
  File? _croppedImageFile;

  Future<void> _pickAndCropImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    final CropImageResult? result = await showMaterialImageCropper(
      context,
      imageProvider: FileImage(File(pickedFile.path)),
      cropPathFn: aabbCropShapeFn, // rectangular crop shape
      enabledTransformations: [Transformation.resize],
      allowedAspectRatios: null,
      themeData: ThemeData(
        //
        scaffoldBackgroundColor: Colors.black,

        iconTheme: IconThemeData(size: 0),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: WidgetStateProperty.all(Colors.transparent),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
      ),
    );

    if (result != null) {
      // debugPrint('-----imamge cropped successfully -->');
      // // if you also want to preview crop image then uncomment the below code okk
      // final ui.Image uiImage = result.uiImage;
      // final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

      // if (byteData != null) {
      //   final Uint8List bytes = byteData.buffer.asUint8List();

      //   final tempDir = await getTemporaryDirectory();
      //   final File croppedFile = await File(
      //     '${tempDir.path}/cropped_image.png',
      //   ).writeAsBytes(bytes);

      //   setState(() {
      //     _croppedImageFile = croppedFile;
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick & Crop Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_croppedImageFile != null)
              Image.file(
                _croppedImageFile!,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              const Text('No image selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndCropImage,
              child: const Text('Pick and Crop Image'),
            ),
          ],
        ),
      ),
    );
  }
}
