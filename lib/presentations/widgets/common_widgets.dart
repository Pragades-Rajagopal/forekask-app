import 'package:flutter/material.dart';

class CommonWidgets {
  static SnackBar mySnackBar(BuildContext context, String text) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      content: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  static RichText myRichText(
    BuildContext context,
    String text1, {
    String text2 = '',
    String text3 = '',
  }) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        text: text1,
        style: textTheme.bodyMedium!.copyWith(
          color: colorScheme.secondary,
          fontSize: textTheme.bodyMedium?.fontSize,
        ),
        children: [
          TextSpan(
            text: ' $text2',
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.secondary,
              fontSize: textTheme.bodyMedium?.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text: ' $text3',
              style: textTheme.bodyMedium!.copyWith(
                color: colorScheme.secondary,
                fontSize: textTheme.bodyMedium?.fontSize,
              )),
        ],
      ),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }

  static myLoadingIndicator(
    BuildContext context, {
    String text1 = '',
    String text2 = '',
    String text3 = '',
  }) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 18),
              CommonWidgets.myRichText(context, text1,
                  text2: text2, text3: text3),
            ],
          ),
        ),
      ),
    );
  }
}
