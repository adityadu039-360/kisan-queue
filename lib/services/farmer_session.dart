import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FarmerSession {
  FarmerSession({
    required this.name,
    required this.mobile,
  });

  final String name;
  final String mobile;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
    };
  }

  factory FarmerSession.fromMap(Map<String, dynamic> map) {
    return FarmerSession(
      name: map['name']?.toString() ?? '',
      mobile: map['mobile']?.toString() ?? '',
    );
  }
}

class FarmerSessionService {
  static const String _sessionKey = 'farmer_session';

  static Future<void> saveSession({
    required String name,
    required String mobile,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final session = FarmerSession(
      name: name,
      mobile: mobile,
    );

    await prefs.setString(
      _sessionKey,
      jsonEncode(session.toMap()),
    );
  }

  static Future<FarmerSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();

    final savedSession = prefs.getString(_sessionKey);

    if (savedSession == null || savedSession.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(savedSession);

      if (decoded is Map<String, dynamic>) {
        final session = FarmerSession.fromMap(decoded);

        if (session.name.isNotEmpty &&
            session.mobile.isNotEmpty) {
          return session;
        }
      }
    } catch (_) {
      await clearSession();
    }

    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}