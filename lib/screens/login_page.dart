import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onFarmerLogin,
  });

  final void Function(String farmerId) onFarmerLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final farmerIdController = TextEditingController();
  final pinController = TextEditingController();

  bool hidePin = true;

  @override
  void dispose() {
    farmerIdController.dispose();
    pinController.dispose();
    super.dispose();
  }

  void login() {
    final farmerId = farmerIdController.text.trim();
    final pin = pinController.text.trim();

    if (farmerId.isEmpty || pin.isEmpty) {
      _showMessage('Please enter Farmer ID and PIN.');
      return;
    }

    if (pin != '1234') {
      _showMessage('Incorrect PIN. Demo PIN is 1234.');
      return;
    }

    widget.onFarmerLogin(farmerId);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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
            child: Column(
              children: [
                // Logo
                Container(
                  width: 150,
                  height: 150,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/kisan_queue_logo.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Welcome to Kisan Queue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172118),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Login to book your procurement slot',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF687268),
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE1E7E1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Farmer Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172118),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Enter your Farmer ID to continue.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF687268),
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'Farmer ID',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172118),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: farmerIdController,
                        textCapitalization:
                        TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'Example: FARMER-001',
                          prefixIcon: const Icon(
                            Icons.badge_outlined,
                          ),
                          filled: true,
                          fillColor:
                          const Color(0xFFF6F8F4),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'PIN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172118),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: pinController,
                        obscureText: hidePin,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter 4-digit PIN',
                          counterText: '',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePin = !hidePin;
                              });
                            },
                            icon: Icon(
                              hidePin
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                          filled: true,
                          fillColor:
                          const Color(0xFFF6F8F4),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF287A32),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5EB),
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF287A32),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Demo PIN: 1234',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                  Color(0xFF287A32),
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
        ),
      ),
    );
  }
}