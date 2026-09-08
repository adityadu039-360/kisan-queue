import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Farmer Profile',
          style: TextStyle(
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
              // Profile header
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
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Color(0xFF287A32),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Ramesh Kumar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Farmer ID: KQ-F1024',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Verified Farmer',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Personal information
              _sectionTitle('Farmer Information'),

              const SizedBox(height: 12),

              _infoCard(
                icon: Icons.phone_outlined,
                title: 'Mobile Number',
                value: '+91 98765 43210',
              ),

              _infoCard(
                icon: Icons.location_on_outlined,
                title: 'Village',
                value: 'Rampur Village',
              ),

              _infoCard(
                icon: Icons.map_outlined,
                title: 'District',
                value: 'Nashik',
              ),

              _infoCard(
                icon: Icons.agriculture_outlined,
                title: 'Primary Crop',
                value: 'Wheat',
              ),

              const SizedBox(height: 12),

              // Account options
              _sectionTitle('Account'),

              const SizedBox(height: 12),

              _optionTile(
                context: context,
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'English',
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),

              _optionTile(
                context: context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with Kisan Queue',
                onTap: () {
                  _showMessage(
                    context,
                    'Help & Support will be available next.',
                  );
                },
              ),

              _optionTile(
                context: context,
                icon: Icons.info_outline,
                title: 'About Kisan Queue',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Kisan Queue',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.agriculture,
                      color: Color(0xFF287A32),
                    ),
                    children: const [
                      Text(
                        'A simple digital platform to help farmers book procurement slots and track their queue.',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 18),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showMessage(
                      context,
                      'Logout is disabled in this prototype.',
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB3261E),
                    side: const BorderSide(
                      color: Color(0xFFE2B9B6),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Color(0xFF172118),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E7E1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: const Color(0xFFEAF5EB),
            child: Icon(
              icon,
              color: const Color(0xFF287A32),
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
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
                const SizedBox(height: 3),
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

  Widget _optionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E7E1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: CircleAvatar(
          radius: 21,
          backgroundColor: const Color(0xFFEAF5EB),
          child: Icon(
            icon,
            color: const Color(0xFF287A32),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF687268),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF687268),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Choose Language',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(
                dialogContext,
                'English',
              ),
              _languageOption(
                dialogContext,
                'हिन्दी',
              ),
              _languageOption(
                dialogContext,
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
      String language,
      ) {
    return ListTile(
      leading: const Icon(
        Icons.language,
        color: Color(0xFF287A32),
      ),
      title: Text(language),
      onTap: () {
        Navigator.pop(context);
        _showMessage(
          context,
          '$language selected for the prototype.',
        );
      },
    );
  }

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}