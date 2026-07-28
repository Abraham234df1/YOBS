import 'package:flutter/material.dart';

class YobsLogoWidget extends StatelessWidget {
  final double fontSize;

  const YobsLogoWidget({
    super.key,
    this.fontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Y',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111827), // Dark Charcoal
            letterSpacing: -1,
          ),
        ),
        // Gear & Worker Icon for 'Ö'
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.settings_rounded, // Gear
              size: fontSize * 1.05,
              color: const Color(0xFFFF6600), // Figma Bright Orange
            ),
            Icon(
              Icons.engineering_rounded, // Worker helmet
              size: fontSize * 0.55,
              color: const Color(0xFF111827),
            ),
          ],
        ),
        Text(
          'BS',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFFF6600), // Figma Bright Orange
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
