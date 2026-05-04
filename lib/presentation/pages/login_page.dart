import '../../core/router/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../components/overlays/app_overlay_loader.dart';
import '../features/auth/auth_navigation_link.dart';
import '../features/auth/login_form_molecule.dart';
import '../features/auth/auth_header_molecule.dart';
import '../providers/auth/login_controller.dart';
import '../templates/auth_layout_template.dart';
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
          form: const LoginFormMolecule(),
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
