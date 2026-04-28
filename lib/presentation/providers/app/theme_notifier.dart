import 'dart:async';

import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_text_styles.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/data/local/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {

  @override
  FutureOr<ThemeMode> build() async {
    final storage = ref.watch(secureStorageHelperProvider);
    final savedTheme = await storage.getTheme();

    return (savedTheme == 'dark') ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {

    final storage = ref.read(secureStorageHelperProvider);
    final currentMode = state.value ?? ThemeMode.light;

    final newMode = currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    
    state = AsyncData(newMode);

    await storage.saveTheme(theme: newMode == ThemeMode.dark ? 'dark' : 'light');
  }
}

final themeNotifierProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final themeAsync = ref.watch(themeNotifierProvider);
  final mode = themeAsync.value ?? ThemeMode.light;

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
          border: AppColors.border,
          capsuleBg: AppColors.textPrimary,
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
        border: AppColors.border,
        capsuleBg: AppColors.lightGray,
      ),
    ],
  );
});
