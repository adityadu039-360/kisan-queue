import 'package:flutter/material.dart';

import 'screens/alerts_page.dart';
import 'screens/booking_page.dart';
import 'screens/home_page.dart';
import 'screens/queue_page.dart';
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

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (currentIndex) {
      case 1:
        currentPage = const QueuePage();
        break;

      case 2:
        currentPage = const AlertsPage();
        break;

      case 3:
        currentPage = _placeholderPage(
          icon: Icons.person_outline,
          title: 'Farmer Profile',
          message: 'Farmer profile will be available next.',
        );
        break;

      default:
        currentPage = HomePage(
          onBookSlot: openBookingPage,
          onQueue: () {
            selectPage(1);
          },
          onAlerts: () {
            selectPage(2);
          },
          onProfile: () {
            selectPage(3);
          },
        );
    }

    return Scaffold(
      body: currentPage,
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

  Widget _placeholderPage({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 70,
                color: const Color(0xFF287A32),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF687268),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}