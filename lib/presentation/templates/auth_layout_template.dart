import 'package:flutter/material.dart';

class AuthLayoutTemplate extends StatelessWidget {
  final Widget header;
  final Widget form;
  final Widget? footer;

  const AuthLayoutTemplate({
    super.key,
    required this.header,
    required this.form,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    header,
                    const SizedBox(height: 40),
                    form,
                    if (footer != null) ...[
                      const SizedBox(height: 20),
                      footer!,
                      SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
