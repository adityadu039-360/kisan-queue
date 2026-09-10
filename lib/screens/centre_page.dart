import 'package:flutter/material.dart';

class CentrePage extends StatelessWidget {
  const CentrePage({
    super.key,
    required this.onBookSlot,
  });

  final VoidCallback onBookSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Procurement Centre',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.05,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF1DF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Color(0xFF287A32),
                    size: 32,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Government Procurement Centre',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172118),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Official procurement centre for farmer crop submissions and scheduled procurement slots.',
                  style: TextStyle(
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                const Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Color(0xFF287A32),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Government Procurement Centre',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 20,
                      color: Color(0xFF287A32),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '09:00 AM - 04:00 PM',
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: onBookSlot,
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                    ),
                    label: const Text(
                      'Book Procurement Slot',
                    ),
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