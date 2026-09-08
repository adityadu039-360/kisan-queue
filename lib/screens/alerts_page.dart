import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({
    super.key,
    required this.bookingData,
  });

  final Map<String, String>? bookingData;

  @override
  Widget build(BuildContext context) {
    final hasBooking = bookingData != null;

    final token = bookingData?['token'] ?? '—';
    final crop = bookingData?['crop'] ?? '—';
    final quantity = bookingData?['quantity'] ?? '—';
    final centre = bookingData?['centre'] ?? '—';
    final time = bookingData?['time'] ?? '—';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Alerts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All alerts marked as read.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Important Updates',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172118),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Stay updated about your booking and queue.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF687268),
                ),
              ),
              const SizedBox(height: 24),

              if (!hasBooking)
                _alertCard(
                  context: context,
                  icon: Icons.info_outline,
                  title: 'No Active Booking',
                  message:
                  'Book a procurement slot to receive token and queue alerts.',
                  time: 'Now',
                  isImportant: true,
                )
              else ...[
                _alertCard(
                  context: context,
                  icon: Icons.confirmation_number_outlined,
                  title: 'Token Confirmed',
                  message:
                  'Your token $token has been generated for $crop ($quantity kg).',
                  time: 'Just now',
                  isImportant: true,
                ),
                _alertCard(
                  context: context,
                  icon: Icons.people_outline,
                  title: 'Queue Update',
                  message:
                  '12 farmers are currently ahead of you. Estimated wait is 45 minutes.',
                  time: 'Just now',
                  isImportant: true,
                ),
                _alertCard(
                  context: context,
                  icon: Icons.access_time,
                  title: 'Slot Reminder',
                  message:
                  'Your procurement slot is scheduled for $time.',
                  time: 'Today',
                  isImportant: false,
                ),
                _alertCard(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: 'Centre Details',
                  message:
                  '$centre is your selected procurement centre.',
                  time: 'Today',
                  isImportant: false,
                ),
              ],

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF287A32),
                      size: 26,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Farmer Tip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF172118),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Keep your token ready when you reach the procurement centre.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF526052),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alertCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isImportant,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isImportant
              ? const Color(0xFFCFE4D1)
              : const Color(0xFFE1E7E1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isImportant
                ? const Color(0xFFE5F5E7)
                : const Color(0xFFF0F2F0),
            child: Icon(
              icon,
              color: isImportant
                  ? const Color(0xFF287A32)
                  : const Color(0xFF687268),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172118),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF687268),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF929992),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}