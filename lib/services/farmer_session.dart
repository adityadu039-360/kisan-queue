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

  factory FarmerSession.fromMap(
      Map<String, dynamic> map,
      ) {
    return FarmerSession(
      name: map['name']?.toString() ?? '',
      mobile: map['mobile']?.toString() ?? '',
    );
  }
}

class EmployeeSession {
  EmployeeSession({
    required this.employeeId,
  });

  final String employeeId;

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
    };
  }

  factory EmployeeSession.fromMap(
      Map<String, dynamic> map,
      ) {
    return EmployeeSession(
      employeeId: map['employeeId']?.toString() ?? '',
    );
  }
}

class FarmerSessionService {
  static const String _farmerSessionKey =
      'farmer_session';

  static const String _employeeSessionKey =
      'employee_session';

  static Future<void> saveFarmerSession({
    required String name,
    required String mobile,
  }) async {
    final prefs =
    await SharedPreferences.getInstance();

    final session = FarmerSession(
      name: name,
      mobile: mobile,
    );

    await prefs.setString(
      _farmerSessionKey,
      jsonEncode(session.toMap()),
    );
  }

  static Future<FarmerSession?> getFarmerSession() async {
    final prefs =
    await SharedPreferences.getInstance();

    final savedSession =
    prefs.getString(_farmerSessionKey);

    if (savedSession == null ||
        savedSession.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(savedSession);

      if (decoded is Map<String, dynamic>) {
        final session =
        FarmerSession.fromMap(decoded);

        if (session.name.isNotEmpty &&
            session.mobile.isNotEmpty) {
          return session;
        }
      }
    } catch (_) {
      await clearFarmerSession();
    }

    return null;
  }

  static Future<void> clearFarmerSession() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_farmerSessionKey);
  }

  static Future<void> saveEmployeeSession({
    required String employeeId,
  }) async {
    final prefs =
    await SharedPreferences.getInstance();

    final session = EmployeeSession(
      employeeId: employeeId,
    );

    await prefs.setString(
      _employeeSessionKey,
      jsonEncode(session.toMap()),
    );
  }

  static Future<EmployeeSession?>
  getEmployeeSession() async {
    final prefs =
    await SharedPreferences.getInstance();

    final savedSession =
    prefs.getString(_employeeSessionKey);

    if (savedSession == null ||
        savedSession.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(savedSession);

      if (decoded is Map<String, dynamic>) {
        final session =
        EmployeeSession.fromMap(decoded);

        if (session.employeeId.isNotEmpty) {
          return session;
        }
      }
    } catch (_) {
      await clearEmployeeSession();
    }

    return null;
  }

  static Future<void> clearEmployeeSession() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_employeeSessionKey);
  }
}