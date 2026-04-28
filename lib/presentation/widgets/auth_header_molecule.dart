import 'package:eliza_beauty/presentation/widgets/app_tagline.dart';
import 'package:eliza_beauty/presentation/widgets/app_title.dart';
import 'package:flutter/material.dart';

class AuthHeaderMolecule extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeaderMolecule({
    super.key,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTitle(title: title, color: colorScheme.onSurface),
          SizedBox(height: 8),
          AppTagline(title: subtitle, color: colorScheme.onSurfaceVariant,),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
