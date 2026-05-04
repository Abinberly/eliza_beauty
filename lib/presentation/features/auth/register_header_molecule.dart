import '../../../../core/theme/app_theme.dart';
import '../../components/common/app_tagline.dart';
import '../../components/common/app_title.dart';
import 'package:flutter/material.dart';

class RegisterHeaderMolecule extends StatelessWidget {
  const RegisterHeaderMolecule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTitle(title: context.l10n.createAcc),
          const SizedBox(height: 8),
          AppTagline(title: context.l10n.registerDesc),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}