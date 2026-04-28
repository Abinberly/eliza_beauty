import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/core/utils/validation_utils.dart';
import 'package:eliza_beauty/presentation/widgets/app_text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterFormMolecule extends HookConsumerWidget {
  const RegisterFormMolecule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final theme = context.colorScheme;
    final custom = context.customColors;
    final l10n = context.l10n;

    // final registerState = ref.watch(registerControllerProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            id: 'register_name',
            label: l10n.fullName,
            hint: l10n.fullNameHint,
            controller: nameController,
            keyboardType: TextInputType.name,
            validator: (value) => value != null && value.isNotEmpty
                ? null
                : l10n.errNameRequired,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            id: 'register_email',
            label: l10n.email,
            hint: l10n.emailHint,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            id: 'register_password',
            label: l10n.password,
            hint: '*******',
            isPassword: true,
            controller: passwordController,
            validator: ValidationUtils.validatePassword,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            id: 'register_confirm_password',
            label: l10n.confirmPass,
            hint: l10n.confirmPassHint,
            isPassword: true,
            controller: confirmPasswordController,
            validator: (value) {
              if (value != passwordController.text) {
                return l10n.errPasswordMatching;
              }
              return ValidationUtils.validatePassword(value);
            },
          ),
          const SizedBox(height: 32),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed:
              //  isLoading
              //     ? null
              //     :
                   () {
                      if (formKey.currentState!.validate()) {
                        // ref.read(registerControllerProvider.notifier).register(...);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.createAcc,
                style: GoogleFonts.inter(
                  color: custom.border,
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
