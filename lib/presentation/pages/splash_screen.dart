import '../../core/theme/app_images.dart';
import '../components/common/indicators/gradient_progress_bar.dart';
import '../components/common/splash_content.dart';
import '../providers/app/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashNotifierProvider, (previous, next) {
      next.whenData((route) {
        if (route != null) {
          context.go(route);
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  /// App Icon
                  Image.asset(AppImages.appLogo),

                  /// App Title & App Tagline
                  const SplashContent(),

                  Image.asset(AppImages.splashItemImage),
                ],
              ),

              /// Progress bar
              const Positioned(
                left: 24,
                right: 24,
                bottom: 0,
                child: GradientProgressBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
