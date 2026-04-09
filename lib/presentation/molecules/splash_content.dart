import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/presentation/atoms/app_tagline.dart';
import 'package:eliza_beauty/presentation/atoms/app_title.dart';
import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTitle(title: AppConstants.appTitle,),
          SizedBox(height: 8),
          AppTagline(title: AppConstants.appTagline),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
