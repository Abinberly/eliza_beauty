import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/atoms/auth_navigation_link.dart';
import 'package:eliza_beauty/presentation/molecules/auth_header_molecule.dart';
import 'package:eliza_beauty/presentation/molecules/forgot_password_form_molecule.dart';
import 'package:eliza_beauty/presentation/templates/auth_layout_template.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthLayoutTemplate(
      header: AuthHeaderMolecule(
        title: l10n.forgotPassword,
        subtitle: l10n.emailRecLinkDec,
      ),
      form: const ForgotPasswordFormMolecule(),
      footer: AuthNavigationLink(
        label: l10n.passRemember,
        actionText: l10n.backToLog,
        onActionPressed: () => context.pop(),
      ),
    );
  }
}