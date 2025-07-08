import 'package:flutter/material.dart';

class ThoughtPreviewScreen extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const ThoughtPreviewScreen({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Preview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
