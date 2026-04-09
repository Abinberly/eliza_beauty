import 'package:eliza_beauty/core/router/app_router.dart';
import 'package:eliza_beauty/presentation/providers/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElizaApp extends ConsumerWidget {
  const ElizaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeNotifierProvider);
    final theme = ref.watch(themeDataProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: theme,
      routerConfig: router,
    );
  }
}
