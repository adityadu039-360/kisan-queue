import 'package:flutter/material.dart';

import '../services/app_language.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.farmerName,
    required this.farmerMobile,
    required this.onLogout,
  });

  final String farmerName;
  final String farmerMobile;
  final Future<void> Function() onLogout;

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppText.chooseLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(
                context,
                AppLanguage.english,
                'English',
              ),
              _languageOption(
                context,
                AppLanguage.hindi,
                'हिंदी',
              ),
              _languageOption(
                context,
                AppLanguage.marathi,
                'मराठी',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(
      BuildContext context,
      AppLanguage language,
      String label,
      ) {
    final selected = appLanguage.value == language;

    return ListTile(
      leading: Icon(
        selected
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: const Color(0xFF287A32),
      ),
      title: Text(label),
      onTap: () {
        appLanguage.value = language;
        Navigator.pop(context);
      },
    );
  }

  Future<void> confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF287A32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (context, language, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F8F4),
          appBar: AppBar(
            title: Text(AppText.farmerProfile),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF287A32),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 52,
                    color: Color(0xFF287A32),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  farmerName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172118),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  AppText.verifiedFarmer,
                  style: const TextStyle(
                    color: Color(0xFF287A32),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      _profileRow(
                        icon: Icons.person_outline,
                        title: 'Name',
                        value: farmerName,
                      ),
                      const Divider(height: 28),
                      _profileRow(
                        icon: Icons.phone_outlined,
                        title: 'Mobile Number',
                        value: '+91 $farmerMobile',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                InkWell(
                  onTap: () {
                    showLanguageDialog(context);
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.language,
                            color: Color(0xFF287A32),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppText.language,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appLanguage
                                    .languageName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      confirmLogout(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                      const Color(0xFFC62828),
                      side: const BorderSide(
                        color: Color(0xFFC62828),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Kisan Queue',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF287A32),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Simple Queue • Smart Notifications • Happier Farmers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7A827A),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF287A32),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172118),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}