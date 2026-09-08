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
  int farmersAhead = 12;
  int estimatedWait = 45;
  int currentPosition = 13;
  int totalQueue = 25;

  Timer? queueTimer;

  @override
  void initState() {
    super.initState();

    if (widget.bookingData != null) {
      queueTimer = Timer.periodic(
        const Duration(seconds: 20),
            (_) {
          moveQueue();
        },
      );
    }
  }

  @override
  void dispose() {
    queueTimer?.cancel();
    super.dispose();
  }

  void moveQueue() {
    if (!mounted || widget.bookingData == null) {
      return;
    }

    if (farmersAhead > 0) {
      setState(() {
        farmersAhead--;
        estimatedWait = farmersAhead * 4;
        currentPosition = farmersAhead + 1;
      });
    }
  }

  void refreshQueue() {
    if (widget.bookingData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please book a procurement slot first.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    moveQueue();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Queue status updated successfully.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasBooking = widget.bookingData != null;

    final token = widget.bookingData?['token'] ?? '—';
    final crop = widget.bookingData?['crop'] ?? 'No booking yet';
    final quantity = widget.bookingData?['quantity'] ?? '—';
    final centre =
        widget.bookingData?['centre'] ?? 'Book a procurement slot first';
    final date = widget.bookingData?['date'] ?? '—';
    final time = widget.bookingData?['time'] ?? '—';

    final progress = hasBooking && totalQueue > 0
        ? currentPosition / totalQueue
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Live Queue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Queue Status',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172118),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hasBooking
                    ? 'Your live position for today\'s procurement.'
                    : 'Book a procurement slot to join the queue.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF687268),
                ),
              ),
              const SizedBox(height: 24),

              if (!hasBooking)
                _emptyBookingCard()
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF287A32),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'YOUR TOKEN',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        token,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sync,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Queue is moving',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: Icons.people_outline,
                        value: '$farmersAhead',
                        label: 'Farmers Ahead',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        icon: Icons.timer_outlined,
                        value: '$estimatedWait min',
                        label: 'Estimated Wait',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Your Booking',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172118),
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE1E7E1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _bookingRow(
                        Icons.grass,
                        'Crop',
                        crop,
                      ),
                      _bookingRow(
                        Icons.scale_outlined,
                        'Quantity',
                        '$quantity kg',
                      ),
                      _bookingRow(
                        Icons.location_on_outlined,
                        'Centre',
                        centre,
                      ),
                      _bookingRow(
                        Icons.calendar_today_outlined,
                        'Date',
                        date,
                      ),
                      _bookingRow(
                        Icons.schedule_outlined,
                        'Time',
                        time,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Queue Progress',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172118),
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFE1E7E1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current position',
                            style: TextStyle(
                              color: Color(0xFF687268),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '$currentPosition / $totalQueue',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 12,
                          backgroundColor:
                          const Color(0xFFE2E8E2),
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            Color(0xFF287A32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        farmersAhead > 0
                            ? 'You are moving closer to your turn.'
                            : 'It is almost your turn!',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF526052),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Queue Journey',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172118),
                  ),
                ),

                const SizedBox(height: 14),

                _queueStep(
                  icon: Icons.check_circle,
                  title: 'Slot Booked',
                  subtitle:
                  'Your procurement slot is confirmed.',
                  completed: true,
                ),

                _queueStep(
                  icon: Icons.people,
                  title: 'Waiting in Queue',
                  subtitle:
                  '$farmersAhead farmers are currently ahead of you.',
                  completed: true,
                ),

                _queueStep(
                  icon: Icons.local_shipping_outlined,
                  title: 'Procurement',
                  subtitle:
                  'You will be called when your turn arrives.',
                  completed: false,
                ),

                _queueStep(
                  icon: Icons.done_all,
                  title: 'Completed',
                  subtitle:
                  'Procurement successfully completed.',
                  completed: false,
                  isLast: true,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: refreshQueue,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Refresh Queue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF287A32),
                      side: const BorderSide(
                        color: Color(0xFF287A32),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyBookingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE1E7E1),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 60,
            color: Color(0xFF287A32),
          ),
          SizedBox(height: 16),
          Text(
            'No active booking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Book a procurement slot to receive your digital token and join the queue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF687268),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1E7E1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF287A32),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172118),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF687268),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF287A32),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF687268),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _queueStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool completed,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              color: completed
                  ? const Color(0xFF287A32)
                  : const Color(0xFF9AA39A),
              size: 26,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 45,
                color: completed
                    ? const Color(0xFFB8DDBB)
                    : const Color(0xFFDDE2DD),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: completed
                        ? const Color(0xFF172118)
                        : const Color(0xFF7A827A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF687268),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}