import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  final Color color;
  final double? fontSize;
  final List<InlineSpan> inlineSpans;
  final TextAlign textAlign;
  const RichTextWidget({
    super.key,
    required this.color,
    this.fontSize = 14.0,
    this.inlineSpans = const [],
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: color,
              fontSize: fontSize,
            ),
        children: [...inlineSpans],
      ),
    );
  }
}
