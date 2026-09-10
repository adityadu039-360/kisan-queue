import 'package:flutter/material.dart';

import '../services/farmer_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onFarmerLogin,
    required this.onOwnerLogin,
  });

  final void Function(FarmerSession session) onFarmerLogin;
  final VoidCallback onOwnerLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ownerMode = false;
  bool obscurePassword = true;
  bool isLoading = false;

  final farmerNameController = TextEditingController();
  final farmerMobileController = TextEditingController();

  final ownerIdController = TextEditingController();
  final ownerPasswordController = TextEditingController();

  @override
  void dispose() {
    farmerNameController.dispose();
    farmerMobileController.dispose();
    ownerIdController.dispose();
    ownerPasswordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> farmerLogin() async {
    final name = farmerNameController.text.trim();
    final mobile = farmerMobileController.text.trim();

    if (name.isEmpty) {
      showMessage('Please enter farmer name.');
      return;
    }

    if (mobile.length < 10) {
      showMessage('Please enter a valid mobile number.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final session = FarmerSession(
      name: name,
      mobile: mobile,
    );

    widget.onFarmerLogin(session);

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> ownerLogin() async {
    final ownerId = ownerIdController.text.trim();
    final password = ownerPasswordController.text;

    if (ownerId.isEmpty) {
      showMessage('Please enter Owner ID.');
      return;
    }

    if (password.isEmpty) {
      showMessage('Please enter password.');
      return;
    }

    const validOwnerId = '9353371875';
    const validPassword = 'Derive@32';

    if (ownerId != validOwnerId || password != validPassword) {
      showMessage('Invalid Owner ID or password.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    widget.onOwnerLogin();
  }

  Widget roleButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF287A32)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? Colors.white
                    : const Color(0xFF287A32),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : const Color(0xFF172118),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/logo/kisan_queue_logo.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Kisan Queue',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172118),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    ownerMode
                        ? 'Procurement Centre Owner Login'
                        : 'Farmer Login',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 26),

                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EEE7),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        roleButton(
                          title: 'Farmer',
                          icon: Icons.person_outline,
                          selected: !ownerMode,
                          onTap: () {
                            setState(() {
                              ownerMode = false;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        roleButton(
                          title: 'Owner',
                          icon: Icons.admin_panel_settings_outlined,
                          selected: ownerMode,
                          onTap: () {
                            setState(() {
                              ownerMode = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.05,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ownerMode
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Owner credentials',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),

                        TextField(
                          controller: ownerIdController,
                          keyboardType:
                          TextInputType.number,
                          decoration:
                          const InputDecoration(
                            labelText: 'Owner ID',
                            prefixIcon: Icon(
                              Icons.badge_outlined,
                            ),
                            border:
                            OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller:
                          ownerPasswordController,
                          obscureText: obscurePassword,
                          decoration:
                          InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            border:
                            const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                  !obscurePassword;
                                });
                              },
                              icon: Icon(
                                obscurePassword
                                    ? Icons
                                    .visibility_outlined
                                    : Icons
                                    .visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed:
                            isLoading
                                ? null
                                : ownerLogin,
                            icon: const Icon(
                              Icons.login,
                            ),
                            label: Text(
                              isLoading
                                  ? 'Signing in...'
                                  : 'Owner Login',
                            ),
                          ),
                        ),
                      ],
                    )
                        : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome, Farmer',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          controller:
                          farmerNameController,
                          textCapitalization:
                          TextCapitalization.words,
                          decoration:
                          const InputDecoration(
                            labelText: 'Farmer name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                            border:
                            OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller:
                          farmerMobileController,
                          keyboardType:
                          TextInputType.phone,
                          decoration:
                          const InputDecoration(
                            labelText: 'Mobile number',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                            ),
                            border:
                            OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed:
                            isLoading
                                ? null
                                : farmerLogin,
                            icon: const Icon(
                              Icons.login,
                            ),
                            label: Text(
                              isLoading
                                  ? 'Signing in...'
                                  : 'Farmer Login',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    ownerMode
                        ? 'Authorized procurement centre access'
                        : 'Book procurement slots and track your queue',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}