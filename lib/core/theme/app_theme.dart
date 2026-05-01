import 'package:flutter/material.dart';
import 'color_theme.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData get light =>
      MaterialTheme(textTheme: AppTextTheme.textTheme).light();

  static ThemeData get dark =>
      MaterialTheme(textTheme: AppTextTheme.textTheme).dark();
}
