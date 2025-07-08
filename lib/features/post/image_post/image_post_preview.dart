import 'dart:io';

import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final File image;
  final String text;
  final Color textColor;
  final double fontSize;
  final Offset textPosition;

  const PreviewScreen({
    super.key,
    required this.image,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.textPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: Stack(
        children: [
          Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
          if (text.isNotEmpty)
            Positioned(
              left: textPosition.dx,
              top: textPosition.dy,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width - textPosition.dx - 20,
                ),
                child: Text(
                  text,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
