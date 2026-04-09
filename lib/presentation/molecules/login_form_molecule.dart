import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/core/utils/validation_utils.dart';
import 'package:eliza_beauty/presentation/atoms/app_text_formfield.dart';
import 'package:eliza_beauty/presentation/providers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginFormMolecule extends HookConsumerWidget {
  const LoginFormMolecule({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final theme = context.colorScheme;
    final custom = context.customColors;

    final loginState = ref.watch(loginControllerProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            id: 'login_email',
            label: AppConstants.email,
            hint: AppConstants.emailHint,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            id: 'login_password',
            label: AppConstants.password,
            hint: AppConstants.passwordHint,
            isPassword: true,
            controller: passwordController,
            validator: ValidationUtils.validatePassword,
          ),

          const SizedBox(height: 16),

          ///Forgot password button
          Row(
            children: [
              Spacer(),

              TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppConstants.forgotPassword,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.forgotPass,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: loginState.isLoading
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(loginControllerProvider.notifier)
                            .login(
                              emailController.text,
                              passwordController.text,
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppConstants.signIn,
                style: GoogleFonts.inter(
                  color: custom.border,
                  fontWeight: .w600,
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
