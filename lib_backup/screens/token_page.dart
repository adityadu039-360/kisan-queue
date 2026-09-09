import 'package:flutter/material.dart';

class TokenPage extends StatelessWidget {
  final String tokenNumber;
  final String crop;
  final String quantity;
  final String centre;
  final String date;
  final String time;

  const TokenPage({
    super.key,
    required this.tokenNumber,
    required this.crop,
    required this.quantity,
    required this.centre,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Digital Token',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F8F4),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Success message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F5E7),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF287A32),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Confirmed!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your procurement slot is reserved.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF48634B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Main token card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'YOUR TOKEN NUMBER',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFF6A746B),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      tokenNumber,
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF287A32),
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 17,
                            color: Color(0xFF8A6200),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Waiting for your turn',
                            style: TextStyle(
                              color: Color(0xFF8A6200),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Queue information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF287A32),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Current Queue',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '12 Farmers Ahead',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Estimated waiting time: 45 minutes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Booking details
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
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172118),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _detailRow(
                      Icons.grass,
                      'Crop',
                      crop,
                    ),

                    _detailRow(
                      Icons.scale_outlined,
                      'Quantity',
                      '$quantity kg',
                    ),

                    _detailRow(
                      Icons.location_on_outlined,
                      'Procurement Centre',
                      centre,
                    ),

                    _detailRow(
                      Icons.calendar_today_outlined,
                      'Date',
                      date,
                    ),

                    _detailRow(
                      Icons.schedule_outlined,
                      'Time Slot',
                      time,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Important instruction
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF286090),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please reach the procurement centre before your selected slot and keep your documents ready.',
                        style: TextStyle(
                          color: Color(0xFF31506B),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home_outlined),
                  label: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF287A32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: const Color(0xFF287A32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF707970),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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