import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerRecord {
  FarmerRecord({
    required this.name,
    required this.mobile,
    required this.lastLogin,
  });

  final String name;
  final String mobile;
  final String lastLogin;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'lastLogin': lastLogin,
    };
  }

  factory FarmerRecord.fromMap(Map<String, dynamic> map) {
    return FarmerRecord(
      name: map['name']?.toString() ?? '',
      mobile: map['mobile']?.toString() ?? '',
      lastLogin: map['lastLogin']?.toString() ?? '',
    );
  }
}

class FarmerBooking {
  FarmerBooking({
    required this.token,
    required this.farmerName,
    required this.farmerMobile,
    required this.crop,
    required this.quantity,
    required this.centre,
    required this.date,
    required this.time,
  });

  final String token;
  final String farmerName;
  final String farmerMobile;
  final String crop;
  final String quantity;
  final String centre;
  final String date;
  final String time;

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'farmerName': farmerName,
      'farmerMobile': farmerMobile,
      'crop': crop,
      'quantity': quantity,
      'centre': centre,
      'date': date,
      'time': time,
    };
  }

  factory FarmerBooking.fromMap(Map<String, dynamic> map) {
    return FarmerBooking(
      token: map['token']?.toString() ?? '',
      farmerName: map['farmerName']?.toString() ?? '',
      farmerMobile: map['farmerMobile']?.toString() ?? '',
      crop: map['crop']?.toString() ?? '',
      quantity: map['quantity']?.toString() ?? '',
      centre: map['centre']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
    );
  }
}

class FarmerDataService extends ChangeNotifier {
  FarmerDataService._();

  static final FarmerDataService instance =
  FarmerDataService._();

  static const String _farmersKey = 'farmers_data';
  static const String _bookingsKey = 'farmer_bookings';
  static const String _cropsKey = 'procurement_crops';
  static const String _totalSlotsKey =
      'procurement_total_slots';
  static const String _tokenCounterKey =
      'procurement_token_counter';

  List<FarmerRecord> _farmers = [];
  List<FarmerBooking> _bookings = [];

  List<String> _crops = [
    'Wheat',
    'Rice',
    'Maize',
    'Soybean',
  ];

  int _totalSlots = 50;
  int _tokenCounter = 100;

  List<FarmerRecord> get farmers =>
      List.unmodifiable(_farmers);

  List<FarmerBooking> get bookings =>
      List.unmodifiable(_bookings);

  List<String> get crops =>
      List.unmodifiable(_crops);

  int get totalSlots => _totalSlots;

  int get bookedSlots => _bookings.length;

  int get availableSlots {
    final available = _totalSlots - _bookings.length;

    return available < 0 ? 0 : available;
  }

  Future<void> loadData() async {
    final prefs =
    await SharedPreferences.getInstance();

    final farmersJson =
    prefs.getString(_farmersKey);

    if (farmersJson != null &&
        farmersJson.isNotEmpty) {
      try {
        final decoded =
        jsonDecode(farmersJson);

        if (decoded is List) {
          _farmers = decoded
              .whereType<Map>()
              .map(
                (item) => FarmerRecord.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList();
        }
      } catch (_) {
        _farmers = [];
      }
    }

    final bookingsJson =
    prefs.getString(_bookingsKey);

    if (bookingsJson != null &&
        bookingsJson.isNotEmpty) {
      try {
        final decoded =
        jsonDecode(bookingsJson);

        if (decoded is List) {
          _bookings = decoded
              .whereType<Map>()
              .map(
                (item) => FarmerBooking.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList();
        }
      } catch (_) {
        _bookings = [];
      }
    }

    final savedCrops =
    prefs.getStringList(_cropsKey);

    if (savedCrops != null &&
        savedCrops.isNotEmpty) {
      _crops = List<String>.from(savedCrops);
    }

    _totalSlots =
        prefs.getInt(_totalSlotsKey) ?? 50;

    _tokenCounter =
        prefs.getInt(_tokenCounterKey) ?? 100;

    notifyListeners();
  }

  Future<void> registerFarmer({
    required String name,
    required String mobile,
  }) async {
    final now = DateTime.now().toIso8601String();

    final index = _farmers.indexWhere(
          (farmer) => farmer.mobile == mobile,
    );

    final farmer = FarmerRecord(
      name: name,
      mobile: mobile,
      lastLogin: now,
    );

    if (index >= 0) {
      _farmers[index] = farmer;
    } else {
      _farmers.add(farmer);
    }

    await _saveFarmers();

    notifyListeners();
  }

  Future<void> addBooking({
    required String token,
    required String farmerName,
    required String farmerMobile,
    required String crop,
    required String quantity,
    required String centre,
    required String date,
    required String time,
  }) async {
    final booking = FarmerBooking(
      token: token,
      farmerName: farmerName,
      farmerMobile: farmerMobile,
      crop: crop,
      quantity: quantity,
      centre: centre,
      date: date,
      time: time,
    );

    _bookings.add(booking);

    await _saveBookings();

    notifyListeners();
  }

  String nextToken() {
    _tokenCounter++;

    _saveTokenCounter();

    return 'KQ-$_tokenCounter';
  }

  Future<void> updateCrops(
      List<String> crops,
      ) async {
    final cleanedCrops = crops
        .map((crop) => crop.trim())
        .where((crop) => crop.isNotEmpty)
        .toSet()
        .toList();

    if (cleanedCrops.isEmpty) {
      return;
    }

    _crops = cleanedCrops;

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setStringList(
      _cropsKey,
      _crops,
    );

    notifyListeners();
  }

  Future<void> updateTotalSlots(
      int totalSlots,
      ) async {
    if (totalSlots <= 0) {
      return;
    }

    _totalSlots = totalSlots;

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      _totalSlotsKey,
      _totalSlots,
    );

    notifyListeners();
  }

  Future<void> _saveFarmers() async {
    final prefs =
    await SharedPreferences.getInstance();

    final data = _farmers
        .map((farmer) => farmer.toMap())
        .toList();

    await prefs.setString(
      _farmersKey,
      jsonEncode(data),
    );
  }

  Future<void> _saveBookings() async {
    final prefs =
    await SharedPreferences.getInstance();

    final data = _bookings
        .map((booking) => booking.toMap())
        .toList();

    await prefs.setString(
      _bookingsKey,
      jsonEncode(data),
    );
  }

  Future<void> _saveTokenCounter() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      _tokenCounterKey,
      _tokenCounter,
    );
  }
}