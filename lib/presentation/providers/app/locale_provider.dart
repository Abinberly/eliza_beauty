import 'package:eliza_beauty/data/local/language_local_service.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Future<Locale> build() async {
    final settingsService = await ref.watch(languageLocalServiceProvider.future);
    final code = await settingsService.getLanguage();

    return Locale(code ?? 'en');
  }

  Future<void> setLocale(String languageCode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = await ref.read(languageLocalServiceProvider.future);
      await service.updateLanguage(languageCode);
      return Locale(languageCode);
    });
  }
}
