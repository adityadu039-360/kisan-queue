import 'dart:async';

import 'package:flutter/material.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({
    super.key,
    required this.bookingData,
  });

  final Map<String, String>? bookingData;

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  Timer? queueTimer;

  int farmersAhead = 12;
  int estimatedMinutes = 45;

  @override
  void initState() {
    super.initState();

    if (widget.bookingData != null) {
      queueTimer = Timer.periodic(
        const Duration(seconds: 20),
            (_) {
          if (!mounted) {
            return;
          }

          if (farmersAhead > 0) {
            setState(() {
              farmersAhead--;
              estimatedMinutes =
                  farmersAhead * 4;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    queueTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;

    if (booking == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F8F4),
        appBar: AppBar(
          title: const Text(
            'Live Queue',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.queue_outlined,
                    size: 44,
                    color: Color(0xFF287A32),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Active Booking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Book a procurement slot to see your live queue position.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF687268),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final token = booking['token'] ?? '—';
    final crop = booking['crop'] ?? '—';
    final quantity = booking['quantity'] ?? '—';
    final centre = booking['centre'] ?? '—';
    final date = booking['date'] ?? '—';
    final time = booking['time'] ?? '—';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Live Queue',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF287A32),
                borderRadius:
                BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Token',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    token,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.14,
                      ),
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Booking Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Farmers Ahead of You',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF687268),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$farmersAhead',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF287A32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estimated wait: $estimatedMinutes minutes',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _InfoCard(
              icon: Icons.location_on_outlined,
              title: 'Procurement Centre',
              value: centre,
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.grass_outlined,
              title: 'Crop',
              value: crop,
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.scale_outlined,
              title: 'Quantity',
              value: quantity,
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Date',
              value: date,
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.access_time_outlined,
              title: 'Time Slot',
              value: time,
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5EB),
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFF287A32),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Keep an eye on the queue. You will be able to see your position as the queue moves.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF287A32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5EB),
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF287A32),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172118),
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