import 'package:flutter/material.dart';

import '../services/farmer_data.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({
    super.key,
    required this.onLogout,
  });

  final VoidCallback onLogout;

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final FarmerDataService data = FarmerDataService.instance;

  Future<void> addCrop() async {
    final controller = TextEditingController();

    final cropName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Crop'),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Crop name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  Navigator.pop(context, value);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (cropName == null || cropName.trim().isEmpty) {
      return;
    }

    final normalizedName = cropName.trim();

    if (data.crops.contains(normalizedName)) {
      return;
    }

    final updatedCrops = [
      ...data.crops,
      normalizedName,
    ];

    await data.updateCrops(updatedCrops);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> removeCrop(String crop) async {
    if (data.crops.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one crop must remain.'),
        ),
      );
      return;
    }

    final updatedCrops = data.crops
        .where((item) => item != crop)
        .toList();

    await data.updateCrops(updatedCrops);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> updateSlots() async {
    final controller = TextEditingController(
      text: data.totalSlots.toString(),
    );

    final slots = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Available Slots'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Total slots',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(
                  controller.text.trim(),
                );

                if (value != null && value > 0) {
                  Navigator.pop(context, value);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (slots == null) {
      return;
    }

    await data.updateTotalSlots(slots);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFF287A32),
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172118),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget farmerCard(FarmerRecord farmer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8E2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFDDF1DF),
            child: Text(
              farmer.name.isNotEmpty
                  ? farmer.name[0].toUpperCase()
                  : 'F',
              style: const TextStyle(
                color: Color(0xFF287A32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmer.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  farmer.mobile,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last login: ${formatDate(farmer.lastLogin)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingCard(FarmerBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8E2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF1DF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  booking.token,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF287A32),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                booking.farmerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          detailRow('Mobile', booking.farmerMobile),
          detailRow('Crop', booking.crop),
          detailRow('Quantity', '${booking.quantity} kg'),
          detailRow('Centre', booking.centre),
          detailRow('Date', booking.date),
          detailRow('Time', booking.time),
        ],
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
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

  String formatDate(String value) {
    if (value.isEmpty) {
      return 'Unknown';
    }

    try {
      final date = DateTime.parse(value);

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year $hour:$minute';
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Owner Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await data.loadData();

          if (mounted) {
            setState(() {});
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF287A32),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF287A32),
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Procurement Centre Owner',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Government Procurement Centre',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                statCard(
                  icon: Icons.people_outline,
                  title: 'Farmers',
                  value: data.farmers.length.toString(),
                ),
                const SizedBox(width: 10),
                statCard(
                  icon: Icons.event_available,
                  title: 'Booked',
                  value: data.bookedSlots.toString(),
                ),
                const SizedBox(width: 10),
                statCard(
                  icon: Icons.event_note,
                  title: 'Available',
                  value: data.availableSlots.toString(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Centre Management',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Procurement Centre',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Update slots',
                        onPressed: updateSlots,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Government Procurement Centre',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Total slots: ${data.totalSlots}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Booked: ${data.bookedSlots}   •   Available: ${data.availableSlots}',
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Crops',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: addCrop,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.crops.map((crop) {
                  return Chip(
                    label: Text(crop),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => removeCrop(crop),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Farmers Logged In',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${data.farmers.length}',
                  style: const TextStyle(
                    color: Color(0xFF287A32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (data.farmers.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 42,
                      color: Colors.black38,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No farmers have logged in yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...data.farmers.map(farmerCard),

            const SizedBox(height: 26),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Farmer Bookings',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${data.bookings.length}',
                  style: const TextStyle(
                    color: Color(0xFF287A32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (data.bookings.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 42,
                      color: Colors.black38,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No farmer bookings yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...data.bookings.reversed.map(bookingCard),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}