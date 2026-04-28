import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/core/utils/validation_utils.dart';
import 'package:eliza_beauty/presentation/widgets/app_text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordFormMolecule extends HookConsumerWidget {
  const ForgotPasswordFormMolecule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final theme = context.colorScheme;
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            id: 'forgot_email',
            label: l10n.email,
            hint: l10n.emailHint,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {

                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.sendResetLink,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}