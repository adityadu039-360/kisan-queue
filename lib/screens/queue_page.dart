import 'package:flutter/material.dart';

import '../services/farmer_data.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key, required this.bookingData});
  final FarmerBooking? bookingData;

  @override
  Widget build(BuildContext context) {
    if (bookingData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F8F4),
        appBar: AppBar(title: Text('My Procurement Process')),
        body: Center(child: Text('No active booking. Book a slot to start.')),
      );
    }

    final booking = bookingData!;
    final service = FarmerDataService.instance;
    final ahead = service.bookings.indexWhere((b) => b.token == booking.token).clamp(0, service.bookings.length);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(title: const Text('My Procurement Process', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: const Color(0xFF287A32), borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 42),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Your Token', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 3),
                Text(booking.token, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('${booking.crop} • ${booking.quantity} kg', style: const TextStyle(color: Colors.white70)),
              ])),
            ]),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.people_alt_outlined, color: Color(0xFF287A32)),
              const SizedBox(width: 12),
              Expanded(child: Text('Queue position: ${ahead + 1}', style: const TextStyle(fontWeight: FontWeight.w700))),
              Text('~${ahead * 5} min', style: const TextStyle(color: Color(0xFF287A32), fontWeight: FontWeight.w800)),
            ]),
          ),
          const SizedBox(height: 22),
          const Text('5-step procurement process', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...List.generate(FarmerDataService.statusSteps.length, (i) {
            final completed = booking.statusIndex > i;
            final current = booking.statusIndex == i;
            return _StepTile(number: i + 1, title: FarmerDataService.statusSteps[i], completed: completed, current: current);
          }),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFEAF5EB), borderRadius: BorderRadius.circular(18)),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.notifications_active_outlined, color: Color(0xFF287A32)),
              SizedBox(width: 10),
              Expanded(child: Text('Employee updates each step. You will receive an app notification and message update when your status changes.', style: TextStyle(height: 1.45, color: Color(0xFF287A32)))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.title, required this.completed, required this.current});
  final int number;
  final String title;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final active = completed || current;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: active ? const Color(0xFFB9DDBD) : Colors.grey.shade200)),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(shape: BoxShape.circle, color: completed ? const Color(0xFF287A32) : const Color(0xFFEAF5EB)),
          child: Center(child: completed ? const Icon(Icons.check, color: Colors.white, size: 22) : Text('$number', style: const TextStyle(color: Color(0xFF287A32), fontWeight: FontWeight.w900))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: active ? const Color(0xFF172118) : Colors.black45))),
        if (completed) const Icon(Icons.verified_rounded, color: Color(0xFF287A32)) else if (current) const Text('NEXT', style: TextStyle(color: Color(0xFF287A32), fontSize: 11, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}
