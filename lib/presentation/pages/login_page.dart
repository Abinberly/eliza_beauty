import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/widgets/app_overlay_loader.dart';
import 'package:eliza_beauty/presentation/widgets/auth_navigation_link.dart';
import 'package:eliza_beauty/presentation/widgets/login_form_molecule.dart';
import 'package:eliza_beauty/presentation/widgets/auth_header_molecule.dart';
import 'package:eliza_beauty/presentation/providers/auth/login_controller.dart';
import 'package:eliza_beauty/presentation/templates/auth_layout_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControllerProvider);
    final l10n = context.l10n;

    ref.listen<AsyncValue<bool?>>(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (isLoggedIn == true) {
            context.go(AppRoutes.home);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Stack(
      children: [
        AuthLayoutTemplate(
          header: AuthHeaderMolecule(
            title: l10n.welcome,
            subtitle: l10n.signInDesc,
          ),
          form: LoginFormMolecule(),
          footer: AuthNavigationLink(
            label: l10n.accQuery,
            actionText: l10n.createAcc,
            onActionPressed: () => context.push(AppRoutes.register),
          ),
        ),

        if (loginState.isLoading) const AppOverlayLoader(),
      ],
    );
  }
}
