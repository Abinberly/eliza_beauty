import 'package:eliza_beauty/presentation/providers/auth/password_visibility_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppTextFormField extends HookConsumerWidget {
  final String id;
  final String? label;
  final String? hint;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;

  const AppTextFormField({
    super.key,
    required this.id,
    this.label,
    this.hint,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final focusNode = useFocusNode();
    final isObscured = ref.watch(passwordVisibilityProvider(id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.start,
          textDirection: Directionality.of(context),
          obscureText: isPassword ? isObscured : false,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: theme.textTheme.bodyLarge,
          selectionControls: MaterialTextSelectionControls(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: prefixIcon,
            prefixIconColor: colorScheme.onSurfaceVariant,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            suffixIcon: isPassword ? _buildVisibilityToggle(ref) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle(WidgetRef ref) {
    final isObscured = ref.watch(passwordVisibilityProvider(id));

    return IconButton(
      icon: Icon(
        isObscured ? Icons.visibility_off : Icons.visibility,
        size: 20,
      ),
      onPressed: () =>
          ref.read(passwordVisibilityProvider(id).notifier).toggle(),
    );
  }
}
