import 'package:flutter/material.dart';

import '../services/farmer_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onFarmerLogin,
    required this.onEmployeeLogin,
  });

  final void Function(FarmerSession session)
  onFarmerLogin;

  final void Function(String employeeId)
  onEmployeeLogin;

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  bool employeeMode = false;
  bool obscurePassword = true;
  bool isLoading = false;

  final farmerNameController =
  TextEditingController();

  final farmerMobileController =
  TextEditingController();

  final employeeIdController =
  TextEditingController();

  final employeePasswordController =
  TextEditingController();

  @override
  void dispose() {
    farmerNameController.dispose();
    farmerMobileController.dispose();
    employeeIdController.dispose();
    employeePasswordController.dispose();
    super.dispose();
  }

  void showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> farmerLogin() async {
    final name =
    farmerNameController.text.trim();

    final mobile =
    farmerMobileController.text.trim();

    if (name.isEmpty) {
      showMessage(
        'Please enter farmer name.',
      );
      return;
    }

    if (mobile.length != 10 ||
        int.tryParse(mobile) == null) {
      showMessage(
        'Please enter a valid 10-digit mobile number.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final session = FarmerSession(
      name: name,
      mobile: mobile,
    );

    await FarmerSessionService
        .saveFarmerSession(
      name: name,
      mobile: mobile,
    );

    widget.onFarmerLogin(session);
  }

  Future<void> employeeLogin() async {
    final employeeId =
    employeeIdController.text.trim();

    final password =
        employeePasswordController.text;

    if (employeeId.isEmpty) {
      showMessage(
        'Please enter Employee ID.',
      );
      return;
    }

    if (password.isEmpty) {
      showMessage(
        'Please enter password.',
      );
      return;
    }

    const validEmployeeId =
        '9353371875';

    const validPassword =
        'Derive@32';

    if (employeeId != validEmployeeId ||
        password != validPassword) {
      showMessage(
        'Invalid Employee ID or password.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await FarmerSessionService
        .saveEmployeeSession(
      employeeId: employeeId,
    );

    widget.onEmployeeLogin(
      employeeId,
    );
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
          duration:
          const Duration(
            milliseconds: 180,
          ),
          padding:
          const EdgeInsets.symmetric(
            vertical: 13,
          ),
          decoration:
          BoxDecoration(
            color: selected
                ? const Color(
              0xFF287A32,
            )
                : Colors.white,
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected
                    ? Colors.white
                    : const Color(
                  0xFF287A32,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style:
                TextStyle(
                  color: selected
                      ? Colors.white
                      : const Color(
                    0xFF172118,
                  ),
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration decoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border:
      const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F8F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    padding:
                    const EdgeInsets.all(
                      10,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 18,
                          offset:
                          const Offset(
                            0,
                            8,
                          ),
                        ),
                      ],
                    ),
                    child:
                    Image.asset(
                      'assets/logo/kisan_queue_logo.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    'Kisan Queue',
                    style:
                    TextStyle(
                      fontSize: 30,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    employeeMode
                        ? 'Procurement Employee Login'
                        : 'Farmer Login',
                    style:
                    const TextStyle(
                      color:
                      Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.all(
                      5,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFFE8EEE7,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        roleButton(
                          title: 'Farmer',
                          icon:
                          Icons.person_outline,
                          selected:
                          !employeeMode,
                          onTap: () {
                            setState(() {
                              employeeMode =
                              false;
                              isLoading =
                              false;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        roleButton(
                          title: 'Employee',
                          icon: Icons
                              .badge_outlined,
                          selected:
                          employeeMode,
                          onTap: () {
                            setState(() {
                              employeeMode =
                              true;
                              isLoading =
                              false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.all(
                      20,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                        22,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.05,
                          ),
                          blurRadius: 18,
                          offset:
                          const Offset(
                            0,
                            7,
                          ),
                        ),
                      ],
                    ),
                    child: employeeMode
                        ? _employeeForm()
                        : _farmerForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _farmerForm() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome, Farmer',
          style:
          TextStyle(
            fontSize: 19,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        TextField(
          controller:
          farmerNameController,
          textCapitalization:
          TextCapitalization.words,
          decoration: decoration(
            label: 'Farmer name',
            icon:
            Icons.person_outline,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        TextField(
          controller:
          farmerMobileController,
          keyboardType:
          TextInputType.phone,
          maxLength: 10,
          decoration: decoration(
            label: 'Mobile number',
            icon:
            Icons.phone_outlined,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
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
            label: const Text(
              'Farmer Login',
            ),
          ),
        ),
      ],
    );
  }

  Widget _employeeForm() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Employee Access',
          style:
          TextStyle(
            fontSize: 19,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        TextField(
          controller:
          employeeIdController,
          keyboardType:
          TextInputType.number,
          decoration: decoration(
            label: 'Employee ID',
            icon:
            Icons.badge_outlined,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        TextField(
          controller:
          employeePasswordController,
          obscureText:
          obscurePassword,
          decoration:
          InputDecoration(
            labelText: 'Password',
            prefixIcon:
            const Icon(
              Icons.lock_outline,
            ),
            suffixIcon:
            IconButton(
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
            border:
            const OutlineInputBorder(),
            filled: true,
            fillColor:
            Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed:
            isLoading
                ? null
                : employeeLogin,
            icon: const Icon(
              Icons.login,
            ),
            label: const Text(
              'Employee Login',
            ),
          ),
        ),
      ],
    );
  }
}