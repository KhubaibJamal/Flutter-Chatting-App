import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.title,
    required this.fontSize,
    required this.fontWeight,
  });
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: fontSize, fontWeight: fontWeight, color: Colors.white),
    );
  }
}
