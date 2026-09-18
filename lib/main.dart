import 'package:flutter/material.dart';

import 'screens/alerts_page.dart';
import 'screens/booking_page.dart';
import 'screens/centre_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/owner_dashboard.dart';
import 'screens/profile_page.dart';
import 'screens/queue_page.dart';
import 'screens/token_page.dart';
import 'services/app_language.dart';
import 'services/farmer_data.dart';
import 'services/farmer_session.dart';
import 'services/notification_service.dart';
import 'services/permission_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FarmerDataService.instance.loadData();
  await NotificationService.instance.initialize();
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
            scaffoldBackgroundColor: const Color(0xFFF6F8F4),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF287A32)),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
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
  State<LoginPageWrapper> createState() => _LoginPageWrapperState();
}

class _LoginPageWrapperState extends State<LoginPageWrapper> {
  FarmerSession? farmerSession;
  String? employeeId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    restoreSession();
  }

  Future<void> restoreSession() async {
    final farmer = await FarmerSessionService.getSession();
    final employee = await EmployeeSessionService.getSession();
    if (!mounted) return;
    setState(() {
      farmerSession = farmer;
      employeeId = employee;
      loading = false;
    });
  }

  void handleFarmerLogin(FarmerSession session) {
    FarmerDataService.instance.registerFarmer(name: session.name, mobile: session.mobile);
    setState(() {
      farmerSession = session;
      employeeId = null;
    });
  }

  void handleEmployeeLogin(String id) {
    setState(() {
      employeeId = id;
      farmerSession = null;
    });
  }

  Future<void> farmerLogout() async {
    await FarmerSessionService.clearSession();
    if (!mounted) return;
    setState(() => farmerSession = null);
  }

  Future<void> employeeLogout() async {
    await EmployeeSessionService.clearSession();
    if (!mounted) return;
    setState(() => employeeId = null);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (employeeId != null) {
      return OwnerDashboard(employeeId: employeeId!, onLogout: employeeLogout);
    }
    if (farmerSession != null) {
      return MainNavigation(farmerSession: farmerSession!, onLogout: farmerLogout);
    }
    return LoginPage(onFarmerLogin: handleFarmerLogin, onOwnerLogin: handleEmployeeLogin);
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.farmerSession, required this.onLogout});
  final FarmerSession farmerSession;
  final Future<void> Function() onLogout;
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;
  FarmerBooking? currentBooking;

  @override
  void initState() {
    super.initState();
    syncBooking();
    FarmerDataService.instance.addListener(syncBooking);
  }

  @override
  void dispose() {
    FarmerDataService.instance.removeListener(syncBooking);
    super.dispose();
  }

  void syncBooking() {
    final list = FarmerDataService.instance.bookings
        .where((b) => b.farmerMobile == widget.farmerSession.mobile)
        .toList();
    if (mounted) setState(() => currentBooking = list.isEmpty ? null : list.last);
  }

  void selectPage(int index) => setState(() => currentIndex = index);

  Future<void> openBookingPage() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingPage()));
    if (result is! Map) return;

    final location = await PermissionService.getCurrentLocation();
    final booking = <String, String>{
      'token': result['token'].toString(),
      'crop': result['crop'].toString(),
      'quantity': result['quantity'].toString(),
      'centre': result['centre'].toString(),
      'date': result['date'].toString(),
      'time': result['time'].toString(),
      'farmerName': widget.farmerSession.name,
      'farmerMobile': widget.farmerSession.mobile,
    };

    await FarmerDataService.instance.addBooking(
      token: booking['token']!, farmerName: booking['farmerName']!, farmerMobile: booking['farmerMobile']!,
      crop: booking['crop']!, quantity: booking['quantity']!, centre: booking['centre']!,
      date: booking['date']!, time: booking['time']!, latitude: location?.latitude, longitude: location?.longitude,
    );

    await NotificationService.instance.show(
      id: booking['token'].hashCode,
      title: 'Slot Booked Successfully',
      body: 'Official update: ${booking['token']} is booked for ${booking['date']} at ${booking['time']}.',
    );

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => TokenPage(
      tokenNumber: booking['token']!, crop: booking['crop']!, quantity: booking['quantity']!,
      centre: booking['centre']!, date: booking['date']!, time: booking['time']!,
    )));
  }

  void openCentrePage() => Navigator.push(context, MaterialPageRoute(builder: (_) => CentrePage(onBookSlot: openBookingPage)));

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentIndex) {
      case 1:
        page = QueuePage(bookingData: currentBooking);
        break;
      case 2:
        page = AlertsPage(bookingData: currentBooking);
        break;
      case 3:
        page = ProfilePage(farmerName: widget.farmerSession.name, farmerMobile: widget.farmerSession.mobile, onLogout: widget.onLogout);
        break;
      default:
        page = HomePage(
          onBookSlot: openBookingPage, onQueue: () => selectPage(1), onAlerts: () => selectPage(2),
          onProfile: () => selectPage(3), onCentres: openCentrePage,
          bookingData: currentBooking == null ? null : {
            'token': currentBooking!.token, 'crop': currentBooking!.crop, 'quantity': currentBooking!.quantity,
            'centre': currentBooking!.centre, 'date': currentBooking!.date, 'time': currentBooking!.time,
          },
        );
    }
    return Scaffold(
      body: page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex, onDestinationSelected: selectPage,
        backgroundColor: Colors.white, indicatorColor: const Color(0xFFDDF1DF),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: AppText.home),
          NavigationDestination(icon: const Icon(Icons.confirmation_number_outlined), selectedIcon: const Icon(Icons.confirmation_number), label: AppText.queue),
          NavigationDestination(icon: const Icon(Icons.notifications_none), selectedIcon: const Icon(Icons.notifications), label: AppText.alerts),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: AppText.profile),
        ],
      ),
    );
  }
}
