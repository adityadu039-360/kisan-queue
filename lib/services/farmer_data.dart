import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerRecord {
  FarmerRecord({required this.name, required this.mobile, required this.lastLogin});
  final String name;
  final String mobile;
  final String lastLogin;
  Map<String, dynamic> toMap() => {'name': name, 'mobile': mobile, 'lastLogin': lastLogin};
  factory FarmerRecord.fromMap(Map<String, dynamic> m) => FarmerRecord(
        name: m['name']?.toString() ?? '', mobile: m['mobile']?.toString() ?? '', lastLogin: m['lastLogin']?.toString() ?? '');
}

class FarmerMessage {
  FarmerMessage({required this.id, required this.mobile, required this.title, required this.body, required this.createdAt});
  final String id;
  final String mobile;
  final String title;
  final String body;
  final String createdAt;
  Map<String, dynamic> toMap() => {'id': id, 'mobile': mobile, 'title': title, 'body': body, 'createdAt': createdAt};
  factory FarmerMessage.fromMap(Map<String, dynamic> m) => FarmerMessage(
        id: m['id']?.toString() ?? '', mobile: m['mobile']?.toString() ?? '', title: m['title']?.toString() ?? '', body: m['body']?.toString() ?? '', createdAt: m['createdAt']?.toString() ?? '');
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
    this.statusIndex = 0,
    this.latitude,
    this.longitude,
  });

  final String token;
  final String farmerName;
  final String farmerMobile;
  final String crop;
  final String quantity;
  final String centre;
  final String date;
  final String time;
  int statusIndex;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toMap() => {
        'token': token, 'farmerName': farmerName, 'farmerMobile': farmerMobile,
        'crop': crop, 'quantity': quantity, 'centre': centre, 'date': date,
        'time': time, 'statusIndex': statusIndex, 'latitude': latitude, 'longitude': longitude,
      };

  factory FarmerBooking.fromMap(Map<String, dynamic> m) => FarmerBooking(
        token: m['token']?.toString() ?? '', farmerName: m['farmerName']?.toString() ?? '',
        farmerMobile: m['farmerMobile']?.toString() ?? '', crop: m['crop']?.toString() ?? '',
        quantity: m['quantity']?.toString() ?? '', centre: m['centre']?.toString() ?? '',
        date: m['date']?.toString() ?? '', time: m['time']?.toString() ?? '',
        statusIndex: int.tryParse(m['statusIndex']?.toString() ?? '') ?? 0,
        latitude: double.tryParse(m['latitude']?.toString() ?? ''),
        longitude: double.tryParse(m['longitude']?.toString() ?? ''),
      );
}

class FarmerDataService extends ChangeNotifier {
  FarmerDataService._();
  static final instance = FarmerDataService._();

  static const _farmersKey = 'farmers_data';
  static const _bookingsKey = 'farmer_bookings';
  static const _messagesKey = 'farmer_messages';
  static const _cropsKey = 'procurement_crops';
  static const _totalSlotsKey = 'procurement_total_slots';
  static const _tokenCounterKey = 'procurement_token_counter';

  List<FarmerRecord> _farmers = [];
  List<FarmerBooking> _bookings = [];
  List<FarmerMessage> _messages = [];
  List<String> _crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  int _totalSlots = 50;
  int _tokenCounter = 100;

  List<FarmerRecord> get farmers => List.unmodifiable(_farmers);
  List<FarmerBooking> get bookings => List.unmodifiable(_bookings);
  List<FarmerMessage> messagesFor(String mobile) => List.unmodifiable(_messages.where((m) => m.mobile == mobile).toList().reversed);
  List<String> get crops => List.unmodifiable(_crops);
  int get totalSlots => _totalSlots;
  int get bookedSlots => _bookings.length;
  int get availableSlots => (_totalSlots - _bookings.length).clamp(0, _totalSlots);

  static const statusSteps = [
    'Process Started',
    'Quality Checked',
    'Price Confirmed',
    'Weight Confirmed',
    'Process Completed',
  ];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _farmers = _decodeList(prefs.getString(_farmersKey), FarmerRecord.fromMap);
    _bookings = _decodeList(prefs.getString(_bookingsKey), FarmerBooking.fromMap);
    _messages = _decodeList(prefs.getString(_messagesKey), FarmerMessage.fromMap);
    _crops = prefs.getStringList(_cropsKey) ?? _crops;
    _totalSlots = prefs.getInt(_totalSlotsKey) ?? 50;
    _tokenCounter = prefs.getInt(_tokenCounterKey) ?? 100;
    notifyListeners();
  }

  List<T> _decodeList<T>(String? raw, T Function(Map<String, dynamic>) factory) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map>().map((e) => factory(Map<String, dynamic>.from(e))).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> registerFarmer({required String name, required String mobile}) async {
    final record = FarmerRecord(name: name, mobile: mobile, lastLogin: DateTime.now().toIso8601String());
    final i = _farmers.indexWhere((f) => f.mobile == mobile);
    if (i >= 0) _farmers[i] = record; else _farmers.add(record);
    await _saveFarmers();
    notifyListeners();
  }

  String nextToken() {
    _tokenCounter++;
    _saveTokenCounter();
    return 'KQ-$_tokenCounter';
  }

  Future<void> addBooking({
    required String token, required String farmerName, required String farmerMobile,
    required String crop, required String quantity, required String centre,
    required String date, required String time, double? latitude, double? longitude,
  }) async {
    _bookings.add(FarmerBooking(token: token, farmerName: farmerName, farmerMobile: farmerMobile, crop: crop,
        quantity: quantity, centre: centre, date: date, time: time, latitude: latitude, longitude: longitude));
    await _saveBookings();
    await addMessage(farmerMobile, 'Slot Booked Successfully',
        'Official update: your procurement slot $token is booked at $centre for $date, $time. Please arrive on time.');
    notifyListeners();
  }

  Future<void> updateBookingStatus(FarmerBooking booking) async {
    if (booking.statusIndex >= statusSteps.length) return;
    booking.statusIndex++;
    final step = statusSteps[booking.statusIndex - 1];
    await _saveBookings();
    await addMessage(booking.farmerMobile, '$step ✓',
        'Official update: ${booking.token} — $step is completed.');
    if (booking.statusIndex == 1) {
      final i = _bookings.indexWhere((b) => b.token == booking.token);
      final next = i >= 0 && i + 5 < _bookings.length ? _bookings[i + 5] : null;
      if (next != null) {
        await addMessage(next.farmerMobile, 'Queue Update',
            'Token ${booking.token} has checked in. Your token ${next.token} is coming up. Please get ready at the procurement centre.');
      }
    }
    if (booking.statusIndex == statusSteps.length) {
      final i = _bookings.indexWhere((b) => b.token == booking.token);
      await addMessage(booking.farmerMobile, 'Process Completed ✓',
          'Official update: your procurement process for ${booking.token} is completed. Thank you.');
      final next = i >= 0 && i + 1 < _bookings.length ? _bookings[i + 1] : null;
      if (next != null && next.statusIndex == 0) {
        await addMessage(next.farmerMobile, 'Your Turn Has Arrived',
            'Token ${next.token}, your turn has arrived. Please check in at the procurement centre.');
      }
    }
    notifyListeners();
  }

  Future<void> addMessage(String mobile, String title, String body) async {
    _messages.add(FarmerMessage(id: '${DateTime.now().microsecondsSinceEpoch}', mobile: mobile,
        title: title, body: body, createdAt: DateTime.now().toIso8601String()));
    await _saveMessages();
  }

  Future<void> updateCrops(List<String> crops) async {
    final clean = crops.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    if (clean.isEmpty) return;
    _crops = clean;
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_cropsKey, _crops);
    notifyListeners();
  }

  Future<void> updateTotalSlots(int slots) async {
    if (slots <= 0) return;
    _totalSlots = slots;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_totalSlotsKey, slots);
    notifyListeners();
  }

  Future<void> _saveFarmers() async => _setJson(_farmersKey, _farmers.map((e) => e.toMap()).toList());
  Future<void> _saveBookings() async => _setJson(_bookingsKey, _bookings.map((e) => e.toMap()).toList());
  Future<void> _saveMessages() async => _setJson(_messagesKey, _messages.map((e) => e.toMap()).toList());
  Future<void> _setJson(String key, Object value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(value));
  }
  Future<void> _saveTokenCounter() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_tokenCounterKey, _tokenCounter);
  }
}
