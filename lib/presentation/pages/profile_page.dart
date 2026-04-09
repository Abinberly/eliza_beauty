import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/theme/app_images.dart';
import 'package:eliza_beauty/presentation/molecules/settings_tile.dart';
import 'package:eliza_beauty/presentation/organisms/settings_group.dart';
import 'package:eliza_beauty/presentation/providers/login_controller.dart';
import 'package:eliza_beauty/presentation/providers/theme_notifier.dart';
import 'package:eliza_beauty/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProfileProvider, (previous, next) {
      if (!next.isLoading && next.value == null && previous?.value != null) {
       context.go(AppRoutes.login);
      }
    });
    final theme = Theme.of(context);
    final user = ref.watch(userProfileProvider).value;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(AppImages.profilePic),
            ),
            const SizedBox(height: 12),
            Text(
              "${user?.firstName} ${user?.lastName}",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Chip(
              label: const Text("MEMBER"),
              backgroundColor: theme.colorScheme.secondaryContainer,
              labelStyle: TextStyle(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),

            Text(
              user?.email ?? "",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 30),

            SettingsGroup(
              title: "Account",
              children: [
                SettingsTile(
                  icon: Icons.person_outline,
                  title: "Personal Information",
                ),
                SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: "Shipping Addresses",
                ),
                SettingsTile(
                  icon: Icons.payment_outlined,
                  title: "Payment Methods",
                ),
              ],
            ),

            SettingsGroup(
              title: "Preferences",
              children: [
                SettingsTile(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  subtitle: "Stay updated on your deliveries",
                  trailing: Switch(
                    activeThumbColor: theme.colorScheme.primary,
                    value: true,
                    onChanged: (v) {},
                  ),
                ),
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: Switch(
                    activeThumbColor: theme.colorScheme.primary,
                    value: ref.watch(themeNotifierProvider) == ThemeMode.dark,
                    onChanged: (value) =>
                        ref.read(themeNotifierProvider.notifier).toggle(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextButton.icon(
              onPressed: () =>
                  ref.read(loginControllerProvider.notifier).logout(),
              icon: Icon(Icons.logout, color: theme.colorScheme.error),
              label: Text(
                "Log Out",
                style: TextStyle(color: theme.colorScheme.error),
              ),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.colorScheme.errorContainer.withValues(
                  alpha: 0.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
