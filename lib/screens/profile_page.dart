import 'package:flutter/material.dart';

import '../widgets/app_animations.dart';
import '../services/app_language.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppText.chooseLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(
                context: dialogContext,
                language: AppLanguage.english,
                title: 'English',
              ),
              _languageOption(
                context: dialogContext,
                language: AppLanguage.hindi,
                title: 'हिंदी',
              ),
              _languageOption(
                context: dialogContext,
                language: AppLanguage.marathi,
                title: 'मराठी',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption({
    required BuildContext context,
    required AppLanguage language,
    required String title,
  }) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (context, selectedLanguage, child) {
        final isSelected = selectedLanguage == language;

        return ListTile(
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: const Color(0xFF287A32),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            appLanguage.value = language;
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (context, language, child) {
        return AnimatedPage(
          child: Scaffold(
            backgroundColor: const Color(0xFFF6F8F4),
            appBar: AppBar(
              title: Text(
                AppText.farmerProfile,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF287A32),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 44,
                              color: Color(0xFF287A32),
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Ramesh Kumar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${AppText.farmerId}: KQ-F1024',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppText.verifiedFarmer,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _profileCard(
                      icon: Icons.phone_outlined,
                      title: 'Mobile Number',
                      value: '+91 98765 43210',
                    ),

                    _profileCard(
                      icon: Icons.location_on_outlined,
                      title: 'Village',
                      value: 'Rampur Village',
                    ),

                    _profileCard(
                      icon: Icons.map_outlined,
                      title: 'District',
                      value: 'Nashik',
                    ),

                    _profileCard(
                      icon: Icons.grass_outlined,
                      title: 'Primary Crop',
                      value: 'Wheat',
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE1E7E1),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.language,
                              color: Color(0xFF287A32),
                            ),
                            title: Text(
                              AppText.language,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              appLanguage.languageName,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                            onTap: () {
                              showLanguageDialog(context);
                            },
                          ),

                          const Divider(height: 1),

                          ListTile(
                            leading: const Icon(
                              Icons.help_outline,
                              color: Color(0xFF287A32),
                            ),
                            title: const Text(
                              'Help & Support',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Help & Support will be available soon.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),

                          const Divider(height: 1),

                          ListTile(
                            leading: const Icon(
                              Icons.info_outline,
                              color: Color(0xFF287A32),
                            ),
                            title: const Text(
                              'About Kisan Queue',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Kisan Queue',
                                applicationVersion: '1.0.0',
                                applicationIcon: const Icon(
                                  Icons.agriculture,
                                  color: Color(0xFF287A32),
                                  size: 36,
                                ),
                                children: const [
                                  Text(
                                    'A farmer-friendly digital procurement slot and queue management prototype.',
                                  ),
                                ],
                              );
                            },
                          ),

                          const Divider(height: 1),

                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Logout feature will be connected later.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E7E1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFEAF5EB),
            child: Icon(
              icon,
              color: const Color(0xFF287A32),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF687268),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172118),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}