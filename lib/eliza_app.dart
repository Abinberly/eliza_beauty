import 'package:eliza_beauty/core/l10n/app_localizations.dart';
import 'package:eliza_beauty/core/router/app_router.dart';
import 'package:eliza_beauty/presentation/providers/app/locale_provider.dart';
import 'package:eliza_beauty/presentation/providers/app/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElizaApp extends ConsumerWidget {
  const ElizaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeNotifierProvider);
    final theme = ref.watch(themeDataProvider);
    final router = ref.watch(routerProvider);

    // Locale provider
    final localeAsync = ref.watch(appLocaleProvider);

    return localeAsync.when(
      data: (locale) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: theme,
        locale: locale,
        routerConfig: router,

        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: AppLocalizations.supportedLocales,
      ),
      error: (Object error, StackTrace stackTrace) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Initialization Error: $error')),
        ),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
