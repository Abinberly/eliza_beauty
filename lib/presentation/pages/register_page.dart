import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/atoms/auth_navigation_link.dart';
import 'package:eliza_beauty/presentation/molecules/auth_header_molecule.dart';
import 'package:eliza_beauty/presentation/molecules/register_form_molecule.dart';
import 'package:eliza_beauty/presentation/templates/auth_layout_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final registerState = ref.watch(registerControllerProvider);

    final l10n = context.l10n;

    return Stack(
      children: [
        AuthLayoutTemplate(
          header: AuthHeaderMolecule(
            title: l10n.createAcc,
            subtitle: l10n.registerDesc,
          ),
          form: const RegisterFormMolecule(),
          footer: AuthNavigationLink(
            label: l10n.alreadyDesc,
            actionText: l10n.signIn,
            onActionPressed: () => context.pop(),
          ),
        ),
        // if (registerState.isLoading) const AppOverlayLoader(),
      ],
    );
  }
}