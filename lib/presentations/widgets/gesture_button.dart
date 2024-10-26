import 'package:flutter/material.dart';

class GestureButton extends StatelessWidget {
  final void Function() onTap;
  final String buttonText;
  const GestureButton({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(100.0),
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
