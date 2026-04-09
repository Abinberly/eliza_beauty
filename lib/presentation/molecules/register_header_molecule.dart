import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/presentation/atoms/app_tagline.dart';
import 'package:eliza_beauty/presentation/atoms/app_title.dart';
import 'package:flutter/material.dart';

class RegisterHeaderMolecule extends StatelessWidget {
  const RegisterHeaderMolecule({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTitle(title: AppConstants.createAcc),
          SizedBox(height: 8),
          AppTagline(title: AppConstants.registerDesc),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}