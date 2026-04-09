import 'package:eliza_beauty/core/constants/app_constants.dart';
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
    return AuthLayoutTemplate(
      header: const AuthHeaderMolecule(
        title: AppConstants.forgotPassword,
        subtitle: AppConstants.emailRecLinkDec,
      ),
      form: const ForgotPasswordFormMolecule(),
      footer: AuthNavigationLink(
        label: AppConstants.passRemember,
        actionText: AppConstants.backToLog,
        onActionPressed: () => context.pop(),
      ),
    );
  }
}