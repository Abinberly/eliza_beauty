import '../../components/common/app_tagline.dart';
import '../../components/common/app_title.dart';
import 'package:flutter/material.dart';

class AuthHeaderMolecule extends StatelessWidget {

  const AuthHeaderMolecule({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
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
          const SizedBox(height: 8),
          AppTagline(title: subtitle, color: colorScheme.onSurfaceVariant,),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
