import 'package:flutter/material.dart';

class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color success;
  final Color error;
  final Color border;

  const AppCustomColors({
    required this.success,
    required this.error,
    required this.border
  });

  @override
  AppCustomColors copyWith({
    Color? success,
    Color? error,
    Color? border,
    Color? buttonTitle,
  }) {
    return AppCustomColors(
      success: success ?? this.success,
      error: error ?? this.error,
      border: border ?? this.border
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!
    );
  }
}

extension AppThemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  AppCustomColors get customColors =>
      Theme.of(this).extension<AppCustomColors>()!;
}
