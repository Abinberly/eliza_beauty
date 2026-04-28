import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/widgets/app_tagline.dart';
import 'package:eliza_beauty/presentation/widgets/app_title.dart';
import 'package:flutter/material.dart';

class RegisterHeaderMolecule extends StatelessWidget {
  const RegisterHeaderMolecule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTitle(title: context.l10n.createAcc),
          SizedBox(height: 8),
          AppTagline(title: context.l10n.registerDesc),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}