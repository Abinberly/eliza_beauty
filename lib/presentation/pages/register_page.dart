import 'package:eliza_beauty/core/constants/app_constants.dart';
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
    // Assuming you have a registerControllerProvider similar to login
    // final registerState = ref.watch(registerControllerProvider);

    return Stack(
      children: [
        AuthLayoutTemplate(
          header: const AuthHeaderMolecule(
            title: AppConstants.createAcc,
            subtitle: AppConstants.registerDesc,
          ),
          form: const RegisterFormMolecule(),
          footer: AuthNavigationLink(
            label: AppConstants.alreadyDesc,
            actionText: AppConstants.signIn,
            onActionPressed: () => context.pop(),
          ),
        ),
        // if (registerState.isLoading) const AppOverlayLoader(),
      ],
    );
  }
}