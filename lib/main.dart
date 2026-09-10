import 'package:flutter/material.dart';

import 'screens/alerts_page.dart';
import 'screens/booking_page.dart';
import 'screens/centre_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/profile_page.dart';
import 'screens/queue_page.dart';
import 'screens/token_page.dart';
import 'services/app_language.dart';
import 'services/farmer_session.dart';

void main() {
  runApp(const KisanQueueApp());
}

class KisanQueueApp extends StatelessWidget {
  const KisanQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (context, language, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kisan Queue',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor:
            const Color(0xFFF6F8F4),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF287A32),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF6F8F4),
              foregroundColor: Color(0xFF172118),
              elevation: 0,
            ),
          ),
          home: const LoginPageWrapper(),
        );
      },
    );
  }
}

class LoginPageWrapper extends StatefulWidget {
  const LoginPageWrapper({super.key});

  @override
  State<LoginPageWrapper> createState() =>
      _LoginPageWrapperState();
}

class _LoginPageWrapperState
    extends State<LoginPageWrapper> {
  FarmerSession? farmerSession;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSavedSession();
  }

  Future<void> loadSavedSession() async {
    final savedSession =
    await FarmerSessionService.getSession();

    if (!mounted) {
      return;
    }

    setState(() {
      farmerSession = savedSession;
      loading = false;
    });
  }

  void handleFarmerLogin(FarmerSession session) {
    setState(() {
      farmerSession = session;
    });
  }

  Future<void> logout() async {
    await FarmerSessionService.clearSession();

    if (!mounted) {
      return;
    }

    setState(() {
      farmerSession = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F8F4),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF287A32),
          ),
        ),
      );
    }

    if (farmerSession == null) {
      return LoginPage(
        onFarmerLogin: handleFarmerLogin,
      );
    }

    return MainNavigation(
      farmerSession: farmerSession!,
      onLogout: logout,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    required this.farmerSession,
    required this.onLogout,
  });

  final FarmerSession farmerSession;
  final Future<void> Function() onLogout;

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  Map<String, String>? bookingData;

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

    if (result is Map) {
      final newBooking = <String, String>{
        'token': result['token'].toString(),
        'crop': result['crop'].toString(),
        'quantity': result['quantity'].toString(),
        'centre': result['centre'].toString(),
        'date': result['date'].toString(),
        'time': result['time'].toString(),
        'farmerName': widget.farmerSession.name,
        'farmerMobile': widget.farmerSession.mobile,
      };

      setState(() {
        bookingData = newBooking;
      });

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TokenPage(
            tokenNumber: newBooking['token']!,
            crop: newBooking['crop']!,
            quantity: newBooking['quantity']!,
            centre: newBooking['centre']!,
            date: newBooking['date']!,
            time: newBooking['time']!,
          ),
        ),
      );
    }
  }

  void openCentrePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CentrePage(
          onBookSlot: openBookingPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (currentIndex) {
      case 1:
        currentPage = QueuePage(
          bookingData: bookingData,
        );
        break;

      case 2:
        currentPage = AlertsPage(
          bookingData: bookingData,
        );
        break;

      case 3:
        currentPage = ProfilePage(
          farmerName: widget.farmerSession.name,
          farmerMobile: widget.farmerSession.mobile,
          onLogout: widget.onLogout,
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
          onCentres: openCentrePage,
          bookingData: bookingData,
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppText.home,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.confirmation_number_outlined,
            ),
            selectedIcon: const Icon(
              Icons.confirmation_number,
            ),
            label: AppText.queue,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.notifications_none,
            ),
            selectedIcon: const Icon(
              Icons.notifications,
            ),
            label: AppText.alerts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: AppText.profile,
          ),
        ],
      ),
    );
  }
}