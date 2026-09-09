import 'package:flutter/material.dart';

enum AppLanguage {
  english,
  hindi,
  marathi,
}

class AppLanguageNotifier extends ValueNotifier<AppLanguage> {
  AppLanguageNotifier() : super(AppLanguage.english);

  String get languageName {
    switch (value) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिंदी';
      case AppLanguage.marathi:
        return 'मराठी';
    }
  }
}

final appLanguage = AppLanguageNotifier();

class AppText {
  static String get home {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Home';
      case AppLanguage.hindi:
        return 'होम';
      case AppLanguage.marathi:
        return 'मुख्यपृष्ठ';
    }
  }

  static String get queue {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Queue';
      case AppLanguage.hindi:
        return 'कतार';
      case AppLanguage.marathi:
        return 'रांग';
    }
  }

  static String get alerts {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Alerts';
      case AppLanguage.hindi:
        return 'सूचनाएँ';
      case AppLanguage.marathi:
        return 'सूचना';
    }
  }

  static String get profile {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Profile';
      case AppLanguage.hindi:
        return 'प्रोफ़ाइल';
      case AppLanguage.marathi:
        return 'प्रोफाइल';
    }
  }

  static String get language {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Language';
      case AppLanguage.hindi:
        return 'भाषा';
      case AppLanguage.marathi:
        return 'भाषा';
    }
  }

  static String get chooseLanguage {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Choose Language';
      case AppLanguage.hindi:
        return 'भाषा चुनें';
      case AppLanguage.marathi:
        return 'भाषा निवडा';
    }
  }

  static String get farmerProfile {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Farmer Profile';
      case AppLanguage.hindi:
        return 'किसान प्रोफ़ाइल';
      case AppLanguage.marathi:
        return 'शेतकरी प्रोफाइल';
    }
  }

  static String get verifiedFarmer {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Verified Farmer';
      case AppLanguage.hindi:
        return 'सत्यापित किसान';
      case AppLanguage.marathi:
        return 'सत्यापित शेतकरी';
    }
  }

  static String get farmerId {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Farmer ID';
      case AppLanguage.hindi:
        return 'किसान आईडी';
      case AppLanguage.marathi:
        return 'शेतकरी आयडी';
    }
  }

  static String get bookSlot {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Book Procurement Slot';
      case AppLanguage.hindi:
        return 'खरीद स्लॉट बुक करें';
      case AppLanguage.marathi:
        return 'खरेदी स्लॉट बुक करा';
    }
  }

  static String get liveQueue {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Live Queue';
      case AppLanguage.hindi:
        return 'लाइव कतार';
      case AppLanguage.marathi:
        return 'लाइव्ह रांग';
    }
  }

  static String get importantUpdates {
    switch (appLanguage.value) {
      case AppLanguage.english:
        return 'Important Updates';
      case AppLanguage.hindi:
        return 'महत्वपूर्ण अपडेट';
      case AppLanguage.marathi:
        return 'महत्त्वाच्या सूचना';
    }
  }
}