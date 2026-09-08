import 'package:flutter/material.dart';

import 'screens/booking_page.dart';
import 'screens/home_page.dart';
import 'screens/token_page.dart';

void main() {
  runApp(const KisanQueueApp());
}

class KisanQueueApp extends StatelessWidget {
  const KisanQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kisan Queue',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF287A32),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F8F4),
          foregroundColor: Color(0xFF172118),
          elevation: 0,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> openBookingPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookingPage(),
      ),
    );

    if (result is Map && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TokenPage(
            tokenNumber: result['token'],
            crop: result['crop'],
            quantity: result['quantity'],
            centre: result['centre'],
            date: result['date'],
            time: result['time'],
          ),
        ),
      );
    }
  }

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available next 🚜'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(
        onBookSlot: openBookingPage,
        onQueue: () {
          showComingSoon('Live Queue');
        },
        onAlerts: () {
          showComingSoon('Alerts');
        },
        onProfile: () {
          showComingSoon('Farmer Profile');
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: selectPage,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDDF1DF),
        elevation: 3,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Queue',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}