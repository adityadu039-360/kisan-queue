import 'package:flutter/material.dart';

import '../services/farmer_data.dart';
import '../services/message_service.dart';
import '../services/notification_service.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key, required this.employeeId, required this.onLogout});
  final String employeeId;
  final Future<void> Function() onLogout;
  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final data = FarmerDataService.instance;

  @override
  void initState() {
    super.initState();
    data.addListener(refresh);
  }
  @override
  void dispose() { data.removeListener(refresh); super.dispose(); }
  void refresh() { if (mounted) setState(() {}); }

  Future<void> updateBooking(FarmerBooking booking) async {
    if (booking.statusIndex >= FarmerDataService.statusSteps.length) return;
    final next = FarmerDataService.statusSteps[booking.statusIndex];
    await data.updateBookingStatus(booking);
    await NotificationService.instance.show(
      id: booking.token.hashCode ^ booking.statusIndex,
      title: '${booking.token}: $next ✓',
      body: '${booking.farmerName} has been updated to $next.',
    );
    if (mounted) setState(() {});
  }

  Future<void> sendSms(FarmerBooking booking, String body) async {
    final ok = await MessageService.openSmsComposer(mobile: booking.farmerMobile, message: body);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'SMS app opened for ${booking.farmerName}.' : 'No SMS app is available on this device.')));
  }

  Future<void> addCrop() async {
    final c = TextEditingController();
    final value = await showDialog<String>(context: context, builder: (_) => AlertDialog(
      title: const Text('Add Crop'), content: TextField(controller: c, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Crop name')),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('Add'))],
    ));
    c.dispose();
    if (value != null && value.isNotEmpty && !data.crops.contains(value)) await data.updateCrops([...data.crops, value]);
  }

  Future<void> updateSlots() async {
    final c = TextEditingController(text: '${data.totalSlots}');
    final value = await showDialog<int>(context: context, builder: (_) => AlertDialog(
      title: const Text('Total Procurement Slots'), content: TextField(controller: c, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total slots')),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final n = int.tryParse(c.text); if (n != null && n > 0) Navigator.pop(context, n); }, child: const Text('Save'))],
    ));
    c.dispose();
    if (value != null) await data.updateTotalSlots(value);
  }

  Widget stat(String title, String value, IconData icon) => Expanded(child: Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: const Color(0xFF287A32)), const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))]),
  ));

  Widget bookingCard(FarmerBooking b) {
    final done = b.statusIndex == FarmerDataService.statusSteps.length;
    final next = done ? 'Completed' : FarmerDataService.statusSteps[b.statusIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: done ? const Color(0xFFB9DDBD) : Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFEAF5EB), borderRadius: BorderRadius.circular(10)), child: Text(b.token, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF287A32)))), const SizedBox(width: 10), Expanded(child: Text(b.farmerName, style: const TextStyle(fontWeight: FontWeight.w900))), Text(b.statusIndex.toString() + '/5', style: const TextStyle(color: Color(0xFF287A32), fontWeight: FontWeight.bold))]),
        const SizedBox(height: 10),
        Text('${b.crop} • ${b.quantity} kg', style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 5), Text('${b.farmerMobile} • ${b.date} • ${b.time}', style: const TextStyle(fontSize: 12, color: Colors.black45)),
        const SizedBox(height: 14),
        LinearProgressIndicator(value: b.statusIndex / 5, minHeight: 7, borderRadius: BorderRadius.circular(10)),
        const SizedBox(height: 10),
        Text(done ? 'Process Completed' : 'Next: $next', style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Row(children: [Expanded(child: FilledButton.icon(onPressed: done ? null : () => updateBooking(b), icon: Icon(done ? Icons.check : Icons.arrow_forward), label: Text(done ? 'Completed' : 'Mark $next'))), const SizedBox(width: 8), IconButton(tooltip: 'SMS', onPressed: () => sendSms(b, done ? 'Official Kisan Queue update: ${b.token} process completed.' : 'Official Kisan Queue update: ${b.token} is now $next.'), icon: const Icon(Icons.sms_outlined))]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(title: const Text('Employee Dashboard', style: TextStyle(fontWeight: FontWeight.w900)), actions: [IconButton(onPressed: () async { await data.loadData(); }, icon: const Icon(Icons.refresh)), IconButton(onPressed: widget.onLogout, icon: const Icon(Icons.logout))]),
      body: RefreshIndicator(
        onRefresh: data.loadData,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF287A32), borderRadius: BorderRadius.circular(22)), child: Row(children: [const CircleAvatar(radius: 27, backgroundColor: Colors.white, child: Icon(Icons.badge_rounded, color: Color(0xFF287A32), size: 30)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Government Procurement Centre', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text('Employee ID: ${widget.employeeId}', style: const TextStyle(color: Colors.white70))]))])),
          const SizedBox(height: 16),
          Row(children: [stat('Farmers', '${data.farmers.length}', Icons.people_alt_outlined), const SizedBox(width: 10), stat('Booked', '${data.bookedSlots}', Icons.event_available), const SizedBox(width: 10), stat('Available', '${data.availableSlots}', Icons.event_note)]),
          const SizedBox(height: 24),
          Row(children: [const Expanded(child: Text('Centre Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))), IconButton(onPressed: updateSlots, icon: const Icon(Icons.edit_outlined))]),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Text('Government Procurement Centre\n${data.totalSlots} total slots • ${data.availableSlots} available', style: const TextStyle(height: 1.5, fontWeight: FontWeight.w700))),
          const SizedBox(height: 22),
          Row(children: [const Expanded(child: Text('Crops', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))), FilledButton.icon(onPressed: addCrop, icon: const Icon(Icons.add), label: const Text('Add'))]),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Wrap(spacing: 8, children: data.crops.map((c) => Chip(label: Text(c), onDeleted: data.crops.length > 1 ? () => data.updateCrops(data.crops.where((x) => x != c).toList()) : null)).toList())),
          const SizedBox(height: 24),
          const Text('Booked Customers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          if (data.bookings.isEmpty) Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: const Column(children: [Icon(Icons.assignment_outlined, size: 44, color: Colors.black38), SizedBox(height: 8), Text('No customers have booked yet.')])),
          ...data.bookings.map(bookingCard),
          const SizedBox(height: 20),
          const Text('Registered Farmers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...data.farmers.map((f) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(children: [CircleAvatar(backgroundColor: const Color(0xFFEAF5EB), child: Text(f.name.isEmpty ? 'F' : f.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF287A32), fontWeight: FontWeight.bold))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(f.name, style: const TextStyle(fontWeight: FontWeight.w800)), Text(f.mobile, style: const TextStyle(color: Colors.black54))]))])),
        ]),
      ),
    );
  }
}
