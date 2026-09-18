import 'package:flutter/material.dart';

import '../services/farmer_data.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key, required this.bookingData});
  final FarmerBooking? bookingData;

  @override
  Widget build(BuildContext context) {
    final mobile = bookingData?.farmerMobile;
    final messages = mobile == null ? <FarmerMessage>[] : FarmerDataService.instance.messagesFor(mobile);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(title: const Text('Messages & Alerts', style: TextStyle(fontWeight: FontWeight.w800))),
      body: messages.isEmpty
          ? const Center(child: Padding(padding: EdgeInsets.all(30), child: Text('Your official booking and queue updates will appear here.', textAlign: TextAlign.center)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade200)),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAF5EB), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.notifications_active_outlined, color: Color(0xFF287A32))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m.title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(m.body, style: const TextStyle(height: 1.4, color: Colors.black54))])),
                  ]),
                );
              },
            ),
    );
  }
}
