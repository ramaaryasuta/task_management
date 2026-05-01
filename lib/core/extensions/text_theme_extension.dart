import 'package:flutter/material.dart';

extension TextThemeExtension on BuildContext {
  TextTheme get _text => Theme.of(this).textTheme;

  // ── Display ──────────────────────────────────────
  TextStyle? get displayLargeTextStyle => _text.displayLarge;
  TextStyle? get displayMediumTextStyle => _text.displayMedium;
  TextStyle? get displaySmallTextStyle => _text.displaySmall;

  // ── Headline ─────────────────────────────────────
  TextStyle? get headlineLargeTextStyle => _text.headlineLarge;
  TextStyle? get headlineMediumTextStyle => _text.headlineMedium;
  TextStyle? get headlineSmallTextStyle => _text.headlineSmall;

  // ── Title ─────────────────────────────────────────
  TextStyle? get titleLargeTextStyle => _text.titleLarge;
  TextStyle? get titleMediumTextStyle => _text.titleMedium;
  TextStyle? get titleSmallTextStyle => _text.titleSmall;

  // ── Body ──────────────────────────────────────────
  TextStyle? get bodyLargeTextStyle => _text.bodyLarge;
  TextStyle? get bodyMediumTextStyle => _text.bodyMedium;
  TextStyle? get bodySmallTextStyle => _text.bodySmall;

  // ── Label ─────────────────────────────────────────
  TextStyle? get labelLargeTextStyle => _text.labelLarge;
  TextStyle? get labelMediumTextStyle => _text.labelMedium;
  TextStyle? get labelSmallTextStyle => _text.labelSmall;
}
