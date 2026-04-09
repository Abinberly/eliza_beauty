import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_text_styles.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeNotifierProvider);

  if (mode == ThemeMode.dark) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        surface: AppColors.cardDark,
        error: AppColors.error,
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
      ),
      textTheme: AppTextStyles.getDarkTextTheme().apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
      extensions: [
        const AppCustomColors(
          success: AppColors.success,
          error: AppColors.error,
          border: AppColors.border
        ),
      ],
    );
  }

  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
      error: AppColors.error,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
    ),
    textTheme: AppTextStyles.getLightTextTheme().apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    extensions: [
      const AppCustomColors(
        success: AppColors.success,
        error: AppColors.error,
        border: AppColors.border
      ),
    ],
  );
});
