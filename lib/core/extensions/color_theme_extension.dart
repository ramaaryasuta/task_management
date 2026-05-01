import 'package:flutter/material.dart';

extension ColorThemeExtension on BuildContext {
  ThemeData get _theme => Theme.of(this);

  ColorScheme get _colorScheme => _theme.colorScheme;

  // Color list
  Color get primaryColor => _colorScheme.primary;
  Color get primaryContainerColor => _colorScheme.primaryContainer;
  Color get onPrimaryColor => _colorScheme.onPrimary;
  Color get onPrimaryContainerColor => _colorScheme.onPrimaryContainer;

  Color get secondaryColor => _colorScheme.secondary;
  Color get secondaryContainerColor => _colorScheme.secondaryContainer;
  Color get onSecondaryColor => _colorScheme.onSecondary;
  Color get onSecondaryContainerColor => _colorScheme.onSecondaryContainer;

  Color get tertiaryColor => _colorScheme.tertiary;
  Color get tertiaryContainerColor => _colorScheme.tertiaryContainer;
  Color get onTertiaryColor => _colorScheme.onTertiary;
  Color get onTertiaryContainerColor => _colorScheme.onTertiaryContainer;

  Color get errorColor => _colorScheme.error;
  Color get errorContainerColor => _colorScheme.errorContainer;
  Color get onErrorColor => _colorScheme.onError;
  Color get onErrorContainerColor => _colorScheme.onErrorContainer;

  Color get surfaceColor => _colorScheme.surface;
  Color get onSurfaceColor => _colorScheme.onSurface;

  Color get outlineColor => _colorScheme.outline;
  Color get outlineVariantColor => _colorScheme.outlineVariant;
  Color get shadowColor => _colorScheme.shadow;
  Color get scrimColor => _colorScheme.scrim;
  Color get inverseSurfaceColor => _colorScheme.inverseSurface;
  Color get inversePrimaryColor => _colorScheme.inversePrimary;

  Color get primaryFixedColor => _colorScheme.primaryFixed;
  Color get secondaryFixedColor => _colorScheme.secondaryFixed;
  Color get tertiaryFixedColor => _colorScheme.tertiaryFixed;
}
