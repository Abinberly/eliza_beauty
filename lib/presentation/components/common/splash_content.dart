import '../../../core/theme/app_theme.dart';
import 'app_tagline.dart';
import 'app_title.dart';
import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTitle(title: l10n.appTitle,),
          const SizedBox(height: 8),
          AppTagline(title: l10n.appTagline),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
