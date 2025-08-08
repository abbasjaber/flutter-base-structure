import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;

        return Scaffold(
          appBar: CommonAppBar(
            title: 'Profile'.tr(),
            showBackButton: false,
            showMenu: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(context, user),
                const SizedBox(height: 24),

                // User Information Section
                _buildUserInfoSection(context, user),
                const SizedBox(height: 24),

                // Actions Section
                _buildActionsSection(context, authProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PrimeColors.primaryRed,
            PrimeColors.darkRed,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PrimeColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: PrimeColors.pureWhite.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: PrimeColors.pureWhite.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: PrimeColors.pureWhite,
            ),
          ),
          const SizedBox(height: 16),

          // User Name
          Text(
            user?.name ?? 'User Name'.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: PrimeColors.pureWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // User Position
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: PrimeColors.pureWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user?.position ?? 'Position'.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: PrimeColors.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PrimeColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PrimeColors.lightGray.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: PrimeColors.lightGray.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Information'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: PrimeColors.pureBlack,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('ID'.tr(), user?.id?.toString() ?? 'N/A', Icons.badge),
          _buildInfoRow(
              'Username'.tr(), user?.username ?? 'N/A', Icons.person_outline),
          _buildInfoRow('Email'.tr(), user?.email ?? 'N/A', Icons.email),
          _buildInfoRow('Position'.tr(), user?.position ?? 'N/A', Icons.work),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PrimeColors.primaryRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: PrimeColors.primaryRed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: PrimeColors.lightGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimeColors.pureBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PrimeColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PrimeColors.lightGray.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: PrimeColors.lightGray.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: PrimeColors.pureBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Language Switch
          InkWell(
            onTap: () => _showLanguageDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PrimeColors.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: PrimeColors.primaryRed.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PrimeColors.primaryRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.language,
                      size: 20,
                      color: PrimeColors.pureWhite,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Language'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: PrimeColors.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Switch between English and Arabic'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: PrimeColors.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: PrimeColors.lightGray,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Logout Button
          InkWell(
            onTap: () => _showLogoutDialog(context, authProvider),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PrimeColors.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: PrimeColors.primaryRed.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PrimeColors.primaryRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                      color: PrimeColors.pureWhite,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logout'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: PrimeColors.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sign out of your account'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: PrimeColors.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: PrimeColors.lightGray,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = context.locale;
    final isEnglish = currentLocale.languageCode == 'en';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return AlertDialog(
            backgroundColor: PrimeColors.pureWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: PrimeColors.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.language,
                    size: 20,
                    color: PrimeColors.primaryRed,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Change Language'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: PrimeColors.pureBlack,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // English Option
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _changeLanguage(context, const Locale('en'), authProvider);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isEnglish
                          ? PrimeColors.primaryRed.withValues(alpha: 0.1)
                          : PrimeColors.lightGray.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isEnglish
                            ? PrimeColors.primaryRed
                            : PrimeColors.lightGray.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isEnglish
                                ? PrimeColors.primaryRed
                                : PrimeColors.lightGray.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: isEnglish
                                ? PrimeColors.pureWhite
                                : Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'English',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isEnglish
                                      ? PrimeColors.primaryRed
                                      : PrimeColors.pureBlack,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'English',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: PrimeColors.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Arabic Option
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _changeLanguage(context, const Locale('ar'), authProvider);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !isEnglish
                          ? PrimeColors.primaryRed.withValues(alpha: 0.1)
                          : PrimeColors.lightGray.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !isEnglish
                            ? PrimeColors.primaryRed
                            : PrimeColors.lightGray.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: !isEnglish
                                ? PrimeColors.primaryRed
                                : PrimeColors.lightGray.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: !isEnglish
                                ? PrimeColors.pureWhite
                                : Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'العربية',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: !isEnglish
                                      ? PrimeColors.primaryRed
                                      : PrimeColors.pureBlack,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Arabic',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: PrimeColors.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: PrimeColors.lightGray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Cancel'.tr(),
                  style: TextStyle(
                    color: PrimeColors.lightGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale newLocale, authProvider) {
    // Change the language
    authProvider.setLocale(newLocale.languageCode);

    setState(() {
      context.setLocale(newLocale);
    });
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newLocale.languageCode == 'en'
              ? 'Language changed to English'.tr()
              : 'تم تغيير اللغة إلى العربية'.tr(),
        ),
        backgroundColor: PrimeColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PrimeColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PrimeColors.primaryRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout,
                  size: 20,
                  color: PrimeColors.primaryRed,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PrimeColors.pureBlack,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: PrimeColors.pureBlack,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: PrimeColors.lightGray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel'.tr(),
                style: TextStyle(
                  color: PrimeColors.lightGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context, authProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PrimeColors.primaryRed,
                foregroundColor: PrimeColors.pureWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Logout'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context, AuthProvider authProvider) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(PrimeColors.primaryRed),
          ),
        );
      },
    );

    // Perform logout
    authProvider.logout();

    // Close loading dialog and navigate to login
    Navigator.of(context).pop();
    context.go('/login');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully logged out'.tr()),
        backgroundColor: PrimeColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
