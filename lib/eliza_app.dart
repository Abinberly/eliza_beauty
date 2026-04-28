import 'package:eliza_beauty/core/l10n/app_localizations.dart';
import 'package:eliza_beauty/core/router/app_router.dart';
import 'package:eliza_beauty/presentation/providers/app/locale_provider.dart';
import 'package:eliza_beauty/presentation/providers/app/theme_notifier.dart';
import 'package:eliza_beauty/presentation/widgets/network_connectivity_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElizaApp extends ConsumerWidget {
  const ElizaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeDataProvider);
    final router = ref.watch(routerProvider);

    // Locale provider
    final localeAsync = ref.watch(appLocaleProvider);

    // Theme Provider
    final themeAsync = ref.watch(themeNotifierProvider);

    return themeAsync.when(
      data: (mode) => localeAsync.when(
        data: (locale) => NetworkConnectivityMonitor(
          child: MaterialApp.router(
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
        ),
        error: (err, stack) => _InitializationErrorWidget(error: err),
        loading: () => const _InitializationLoadingWidget(),
      ),
      error: (err, stack) => _InitializationErrorWidget(error: err),
      loading: () => const _InitializationLoadingWidget(),
    );
  }
}

// Error Widgets
class _InitializationLoadingWidget extends StatelessWidget {
  const _InitializationLoadingWidget();
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _InitializationErrorWidget extends StatelessWidget {
  final Object error;
  const _InitializationErrorWidget({required this.error});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text('Initialization Error: $error'))),
    );
  }
}
