import 'package:eliza_beauty/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color success;
  final Color error;
  final Color border;
  final Color capsuleBg;

  const AppCustomColors({
    required this.success,
    required this.error,
    required this.border,
    required this.capsuleBg,
  });

  @override
  AppCustomColors copyWith({
    Color? success,
    Color? error,
    Color? border,
    Color? buttonTitle,
    Color? capsuleBg,
  }) {
    return AppCustomColors(
      success: success ?? this.success,
      error: error ?? this.error,
      border: border ?? this.border,
      capsuleBg: capsuleBg ?? this.capsuleBg,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!,
      capsuleBg: Color.lerp(capsuleBg, other.capsuleBg, t)!,
    );
  }
}

extension AppThemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  AppCustomColors get customColors =>
      Theme.of(this).extension<AppCustomColors>()!;

      AppLocalizations get l10n => AppLocalizations.of(this)!;
}
