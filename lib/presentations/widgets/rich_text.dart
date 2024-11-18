import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  final Color color;
  final double? fontSize;
  final List<InlineSpan> inlineSpans;
  const RichTextWidget({
    super.key,
    required this.color,
    this.fontSize = 14.0,
    this.inlineSpans = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
        children: [...inlineSpans],
      ),
    );
  }
}
