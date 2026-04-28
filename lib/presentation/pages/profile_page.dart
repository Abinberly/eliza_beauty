import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_images.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/data/local/language_local_service.dart';
import 'package:eliza_beauty/presentation/widgets/settings_tile.dart';
import 'package:eliza_beauty/presentation/widgets/settings_group.dart';
import 'package:eliza_beauty/presentation/providers/app/locale_provider.dart';
import 'package:eliza_beauty/presentation/providers/auth/login_controller.dart';
import 'package:eliza_beauty/presentation/providers/app/theme_notifier.dart';
import 'package:eliza_beauty/presentation/providers/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProfileProvider, (previous, next) {
      if (previous?.value != null && next.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        });
      }
    });
    final theme = Theme.of(context);
    final liveUserAsync = ref.watch(liveUserProfileProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: liveUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          // Offline fallback — use cached profile
          final cachedUser = ref.read(userProfileProvider).value;
          if (cachedUser != null) {
            return _buildProfileContent(context, ref, cachedUser, theme, l10n);
          }
          return Center(child: Text('${l10n.errorPrefix} $e'));
        },
        data: (user) {
          if (user == null) {
            // Fallback to cached
            final cachedUser = ref.read(userProfileProvider).value;
            if (cachedUser != null) {
              return _buildProfileContent(context, ref, cachedUser, theme, l10n);
            }
            return Center(child: Text(l10n.errorPrefix));
          }
          return _buildProfileContent(context, ref, user, theme, l10n);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref, User user, ThemeData theme, dynamic l10n) {
    return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.image.isNotEmpty
                      ? NetworkImage(user.image)
                      : const AssetImage(AppImages.profilePic) as ImageProvider,
                ),
                const SizedBox(height: 12),
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(user.role?.toUpperCase() ?? ""),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),

                Text(
                  user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 30),

                if (user.phone != '' || user.addressText != null)
                  SettingsGroup(
                    title: l10n.contactInfo,
                    children: [
                      if (user.phone != '' && user.phone != null)
                        SettingsTile(
                          icon: Icons.phone_outlined,
                          title: l10n.phoneNumber,
                          subtitle: user.phone,
                        ),
                      if (user.addressText != null)
                        SettingsTile(
                          icon: Icons.location_on_outlined,
                          title: l10n.address,
                          subtitle: user.addressText,
                        ),
                    ],
                  ),

                if (user.role != null || user.companyTitle != null)
                  SettingsGroup(
                    title: l10n.careerDetails,
                    children: [
                      if (user.role != null)
                        SettingsTile(
                          icon: Icons.work_outline,
                          title: l10n.role,
                          subtitle: user.role?.toUpperCase(),
                        ),
                      if (user.companyTitle != null)
                        SettingsTile(
                          icon: Icons.business_center_outlined,
                          title: l10n.jobTitle,
                          subtitle: l10n.jobDescription(
                              '${user.companyTitle}', user.companyDept ?? "" ),
                        ),
                    ],
                  ),

                if (user.age != null || user.bloodGroup != null)
                  SettingsGroup(
                    title: l10n.physicalDetails,
                    children: [
                      if (user.age != null)
                        SettingsTile(
                          icon: Icons.cake_outlined,
                          title: l10n.age,
                          trailing: Text(
                            l10n.ageValue('${user.age}'),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      if (user.bloodGroup != null)
                        SettingsTile(
                          icon: Icons.bloodtype_outlined,
                          title: l10n.bloodGroup,
                          trailing: Text(
                            user.bloodGroup?.toUpperCase() ?? "",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      if (user.height != null)
                        SettingsTile(
                          icon: Icons.height,
                          title: l10n.height,
                          trailing: Text(
                            l10n.heightValue('${user.height}'),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      if (user.weight != null)
                        SettingsTile(
                          icon: Icons.monitor_weight_outlined,
                          title: l10n.weight,
                          trailing: Text(
                            l10n.weightValue('${user.weight}'),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),

                SettingsGroup(
                  title: l10n.preference,
                  children: [
                    SettingsTile(
                      icon: Icons.notifications_none,
                      title: l10n.notifications,
                      subtitle: l10n.deliveryUpdates,
                      trailing: Switch(
                        activeThumbColor: theme.colorScheme.primary,
                        value: true,
                        onChanged: (v) {},
                      ),
                    ),

                    SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: l10n.darkMode,
                      trailing: Switch(
                        activeThumbColor: theme.colorScheme.primary,
                        value:
                            ref.watch(themeNotifierProvider).value == ThemeMode.dark,
                        onChanged: (value) =>
                            ref.read(themeNotifierProvider.notifier).toggle(),
                      ),
                    ),

                    SettingsTile(
                      icon: Icons.language,
                      title: l10n.languages,
                      onTap: () => _showLanguagePicker(context, ref),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: Icon(Icons.logout, color: theme.colorScheme.error),
                  label: Text(
                    l10n.logOut,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: theme.colorScheme.errorContainer
                        .withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  l10n.selectLanguage,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              ListTile(
                title: const Text("English"),
                onTap: () => _updateLocale(ref, context, 'en'),
              ),

              Container(height: 1, color: AppColors.lightGray),

              ListTile(
                title: const Text("العربية"),
                onTap: () => _updateLocale(ref, context, 'ar'),
              ),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _updateLocale(WidgetRef ref, BuildContext context, String code) {
    ref.read(appLocaleProvider.notifier).setLocale(code);
    ref.read(languageLocalServiceProvider).value?.updateLanguage(code);
    context.pop();
  }
}

void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  final theme = context.colorScheme;
  final l10n = context.l10n;

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        l10n.logOut,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
      ),
      content: Text(l10n.logoutConfirmation),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: theme.primary.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => dialogContext.pop(),
                child: Text(l10n.cancel),
              ),
            ),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  dialogContext.pop();
                  ref.read(loginControllerProvider.notifier).logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.logOut),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
