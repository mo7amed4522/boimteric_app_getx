// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/controller/setting_screen_controller/setting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SettingScreenControllerImpl>(
        init: SettingScreenControllerImpl(),
        builder: (controller) => SettingsContent(controller: controller),
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  final SettingScreenControllerImpl controller;

  const SettingsContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(theme),
            const SizedBox(height: 32),

            // Language Section
            _buildLanguageSection(context, theme, isDarkMode),
            const SizedBox(height: 24),

            // Account Section
            _buildAccountSection(context, theme, isDarkMode),
            const SizedBox(height: 24),

            // App Info
            _buildAppInfo(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Center(
      child: Text(
        'settings'.tr,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return Card(
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? theme.cardColor.darken(0.1) : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.language, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'language'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'app_language'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.languageCode,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: theme.cardColor,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeLanguage(newValue);
                    }
                  },
                  items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _getLanguageFlag(value),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              value == 'en' ? 'english'.tr : 'arabic'.tr,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'select_your_preferred_language'.tr,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return Card(
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? theme.cardColor.darken(0.1) : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'account'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'session_management'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmation(context, theme);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: Colors.redAccent.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'sign_out'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'securely_sign_out_of_your_account'.tr,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo(ThemeData theme, bool isDarkMode) {
    return Card(
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? theme.cardColor.darken(0.1) : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.info, color: Colors.green, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'app_information'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow('version'.tr, '1.0.0', theme),
            const SizedBox(height: 12),
            _buildInfoRow('build'.tr, '2026.03.1', theme),
            const SizedBox(height: 12),
            _buildInfoRow('developer'.tr, 'Biometric App Team', theme),
            const SizedBox(height: 12),
            _buildInfoRow('status'.tr, 'production'.tr, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.cardColor,
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.redAccent),
            const SizedBox(width: 12),
            Text(
              'confirm_sign_out'.tr,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        content: Text(
          'are_you_sure_you_want_to_sign_out'.tr,
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text('sign_out'.tr),
          ),
        ],
      ),
    );
  }

  // Helper methods for language selection
  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'ar':
        return '🇸🇦';
      default:
        return '🌐';
    }
  }
}

// Extension for color darkening (add this if not already in the file)
extension ColorExtension on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
