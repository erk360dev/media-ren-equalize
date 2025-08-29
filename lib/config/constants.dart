import 'package:flutter/material.dart';

class AppConstants {
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double defaultBorderRadius = 8.0;
  static const double smallBorderRadius = 4.0;
  static const double largeBorderRadius = 12.0;
  
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Color(0xFF2D2D2D);
  static const Color surfaceColor = Color(0xFF424242);
  static const Color errorColor = Colors.red;
  
  // Text Styles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  
  static const TextStyle captionTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
}