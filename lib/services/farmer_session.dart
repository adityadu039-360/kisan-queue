import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FarmerSession {
  FarmerSession({required this.name, required this.mobile});

  final String name;
  final String mobile;

  Map<String, dynamic> toMap() => {'name': name, 'mobile': mobile};

  factory FarmerSession.fromMap(Map<String, dynamic> map) => FarmerSession(
        name: map['name']?.toString() ?? '',
        mobile: map['mobile']?.toString() ?? '',
      );
}

class FarmerSessionService {
  static const _sessionKey = 'farmer_session';

  static Future<void> saveSession({required String name, required String mobile}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode({'name': name, 'mobile': mobile}));
  }

  static Future<FarmerSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final session = FarmerSession.fromMap(decoded);
        if (session.name.isNotEmpty && session.mobile.isNotEmpty) return session;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

class EmployeeSessionService {
  static const _sessionKey = 'employee_session';

  static Future<void> saveSession({required String employeeId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, employeeId);
  }

  static Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_sessionKey);
    return value == null || value.isEmpty ? null : value;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
