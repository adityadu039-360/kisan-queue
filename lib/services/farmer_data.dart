import 'dart:convert';

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

class FarmerDataService {
  FarmerDataService._();

  static final FarmerDataService instance = FarmerDataService._();

  static const String _farmersKey = 'farmers_data';
  static const String _bookingsKey = 'farmer_bookings';
  static const String _cropsKey = 'procurement_crops';
  static const String _slotsKey = 'total_procurement_slots';

  List<FarmerRecord> farmers = [];

  List<FarmerBooking> bookings = [];

  List<String> crops = [
    'Wheat',
    'Rice',
    'Maize',
    'Bajra',
    'Soybean',
  ];

  int totalSlots = 30;

  int get bookedSlots => bookings.length;

  int get availableSlots {
    final remaining = totalSlots - bookedSlots;
    return remaining < 0 ? 0 : remaining;
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final farmersJson = prefs.getString(_farmersKey);

    if (farmersJson != null && farmersJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(farmersJson);

        if (decoded is List) {
          farmers = decoded
              .whereType<Map>()
              .map(
                (item) => FarmerRecord.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList();
        }
      } catch (_) {
        farmers = [];
      }
    }

    final bookingsJson = prefs.getString(_bookingsKey);

    if (bookingsJson != null && bookingsJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(bookingsJson);

        if (decoded is List) {
          bookings = decoded
              .whereType<Map>()
              .map(
                (item) => FarmerBooking.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList();
        }
      } catch (_) {
        bookings = [];
      }
    }

    final savedCrops = prefs.getStringList(_cropsKey);

    if (savedCrops != null && savedCrops.isNotEmpty) {
      crops = savedCrops;
    }

    totalSlots = prefs.getInt(_slotsKey) ?? 30;
  }

  Future<void> registerFarmer({
    required String name,
    required String mobile,
  }) async {
    final now = DateTime.now().toIso8601String();

    final existingIndex = farmers.indexWhere(
          (farmer) => farmer.mobile == mobile,
    );

    final farmer = FarmerRecord(
      name: name,
      mobile: mobile,
      lastLogin: now,
    );

    if (existingIndex >= 0) {
      farmers[existingIndex] = farmer;
    } else {
      farmers.add(farmer);
    }

    await _saveFarmers();
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

    bookings.add(booking);

    await _saveBookings();
  }

  String nextToken() {
    final number = 104 + bookings.length;
    return 'KQ-$number';
  }

  Future<void> updateCrops(List<String> newCrops) async {
    crops = newCrops;
    await _saveCrops();
  }

  Future<void> updateTotalSlots(int slots) async {
    if (slots < 1) {
      return;
    }

    totalSlots = slots;
    await _saveSlots();
  }

  Future<void> _saveFarmers() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _farmersKey,
      jsonEncode(
        farmers.map((farmer) => farmer.toMap()).toList(),
      ),
    );
  }

  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _bookingsKey,
      jsonEncode(
        bookings.map((booking) => booking.toMap()).toList(),
      ),
    );
  }

  Future<void> _saveCrops() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _cropsKey,
      crops,
    );
  }

  Future<void> _saveSlots() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      _slotsKey,
      totalSlots,
    );
  }
}