import 'package:eliza_beauty/core/local/secure_storage_helper.dart';
import 'package:eliza_beauty/domain/use_case/onboarding_use_case.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_notifier.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  int build() => 0; // Current Page Index

  void nextPage(PageController controller) {
    if (state < 2) {
      state++;
      controller.animateToPage(
        state,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding(BuildContext context, {required VoidCallback onSuccess}) async {
    final storage = ref.read(secureStorageHelperProvider);
    await CompleteOnboardingUseCase(storage).call();

    onSuccess();
  }
}
