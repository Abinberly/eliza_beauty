import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/presentation/providers/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => ref.read(onboardingNotifierProvider.notifier).state = index,
            children:  [
              Container(color: Colors.red, child: const Text(AppConstants.welcomeText)),
              Container(color: Colors.blue, child: const Text(AppConstants.welcomeText)),
              Container(color: Colors.green, child: const Text(AppConstants.welcomeText))
            ],
          ),
          
          Positioned(
            bottom: 50,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: () => ref.read(onboardingNotifierProvider.notifier).completeOnboarding(context, onSuccess: () => context.go(AppRoutes.login)),
                  child: const Text(AppConstants.skip),
                ),
                
                // Next or Done Button
                ElevatedButton(
                  onPressed: () {
                    if (currentPage == 2) {
                      ref.read(onboardingNotifierProvider.notifier).completeOnboarding(context, onSuccess: () => context.go(AppRoutes.login),);
                    } else {
                      ref.read(onboardingNotifierProvider.notifier).nextPage(_pageController);
                    }
                  },
                  child: Text(currentPage == 2 ? AppConstants.getStarted : AppConstants.next),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}