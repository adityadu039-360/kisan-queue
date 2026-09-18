import 'package:flutter/material.dart';

import '../services/farmer_data.dart';
import '../services/farmer_session.dart';
import '../services/message_service.dart';
import '../services/notification_service.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({
    super.key,
    required this.onLogout,
    required this.employeeId,
  });

  final VoidCallback onLogout;
  final String employeeId;

  @override
  State<OwnerDashboard> createState() =>
      _OwnerDashboardState();
}

class _OwnerDashboardState
    extends State<OwnerDashboard> {
  final FarmerDataService data =
      FarmerDataService.instance;

  @override
  void initState() {
    super.initState();

    data.addListener(_refresh);
  }

  @override
  void dispose() {
    data.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> logout() async {
    await FarmerSessionService
        .clearEmployeeSession();

    if (!mounted) {
      return;
    }

    widget.onLogout();
  }

  Future<void> updateProcessStep({
    required FarmerBooking booking,
    required int stepIndex,
  }) async {
    if (booking.completedSteps[stepIndex]) {
      return;
    }

    final success =
    await data.updateBookingStep(
      token: booking.token,
      stepIndex: stepIndex,
    );

    if (!success || !mounted) {
      return;
    }

    await NotificationService.instance
        .processStepCompleted(
      token: booking.token,
      step: procurementSteps[stepIndex],
    );

    if (stepIndex ==
        procurementSteps.length - 1) {
      await NotificationService.instance
          .processCompleted(
        token: booking.token,
      );

      await MessageService
          .sendProcessCompletedMessage(
        mobile: booking.farmerMobile,
        farmerName: booking.farmerName,
        token: booking.token,
      );

      await notifyNextFarmer(booking);
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '${procurementSteps[stepIndex]} updated for ${booking.token}.',
        ),
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> notifyNextFarmer(
      FarmerBooking completedBooking,
      ) async {
    final bookings = data.bookings;

    final currentIndex = bookings.indexWhere(
          (booking) =>
      booking.token ==
          completedBooking.token,
    );

    if (currentIndex < 0) {
      return;
    }

    for (
    var index = currentIndex + 1;
    index < bookings.length;
    index++
    ) {
      final next = bookings[index];

      if (!next.isCompleted) {
        await NotificationService.instance
            .nextFarmerReady(
          token: next.token,
        );

        await MessageService
            .sendNextFarmerMessage(
          mobile: next.farmerMobile,
          farmerName: next.farmerName,
          token: next.token,
        );

        break;
      }
    }
  }

  Future<void> sendFiveQueueUpdate(
      FarmerBooking checkedIn,
      ) async {
    final bookings = data.bookings;

    final currentIndex = bookings.indexWhere(
          (booking) =>
      booking.token == checkedIn.token,
    );

    if (currentIndex < 0) {
      return;
    }

    final targetIndex = currentIndex + 5;

    if (targetIndex >= bookings.length) {
      return;
    }

    final target = bookings[targetIndex];

    await MessageService.sendFiveQueueUpdate(
      mobile: target.farmerMobile,
      farmerName: target.farmerName,
      checkedInToken: checkedIn.token,
      yourToken: target.token,
    );

    await NotificationService.instance
        .showNotification(
      id: '${checkedIn.token}_${target.token}'
          .hashCode,
      title: 'Queue Update',
      body:
      'Token ${checkedIn.token} has checked in. '
          'Your token ${target.token} is coming up.',
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'Queue update prepared for ${target.token}.',
        ),
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addCrop() async {
    final controller =
    TextEditingController();

    final cropName =
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Crop'),
          content: TextField(
            controller: controller,
            textCapitalization:
            TextCapitalization.words,
            decoration:
            const InputDecoration(
              labelText: 'Crop name',
              border:
              OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
              const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value =
                controller.text.trim();

                if (value.isNotEmpty) {
                  Navigator.pop(
                    context,
                    value,
                  );
                }
              },
              child:
              const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (cropName == null ||
        cropName.trim().isEmpty) {
      return;
    }

    final name = cropName.trim();

    if (data.crops.contains(name)) {
      return;
    }

    await data.updateCrops([
      ...data.crops,
      name,
    ]);
  }

  Future<void> removeCrop(
      String crop,
      ) async {
    if (data.crops.length <= 1) {
      return;
    }

    await data.updateCrops(
      data.crops
          .where(
            (item) => item != crop,
      )
          .toList(),
    );
  }

  Future<void> updateSlots() async {
    final controller =
    TextEditingController(
      text: data.totalSlots.toString(),
    );

    final slots =
    await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Update Total Slots',
          ),
          content: TextField(
            controller: controller,
            keyboardType:
            TextInputType.number,
            decoration:
            const InputDecoration(
              labelText: 'Total slots',
              border:
              OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
              const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value =
                int.tryParse(
                  controller.text.trim(),
                );

                if (value != null &&
                    value > 0) {
                  Navigator.pop(
                    context,
                    value,
                  );
                }
              },
              child:
              const Text('Update'),
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
  }

  String formatDate(String value) {
    if (value.isEmpty) {
      return 'Unknown';
    }

    try {
      final date =
      DateTime.parse(value);

      final day =
      date.day.toString().padLeft(2, '0');
      final month =
      date.month.toString().padLeft(2, '0');
      final year =
      date.year.toString();

      final hour =
      date.hour.toString().padLeft(2, '0');
      final minute =
      date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year $hour:$minute';
    } catch (_) {
      return value;
    }
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withValues(
                alpha: 0.05,
              ),
              blurRadius: 14,
              offset:
              const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color:
              const Color(0xFF287A32),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style:
              const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style:
              const TextStyle(
                fontSize: 23,
                fontWeight:
                FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget farmerCard(
      FarmerRecord farmer,
      ) {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          const Color(0xFFE1E7E1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor:
            const Color(0xFFDDF1DF),
            child: Text(
              farmer.name.isNotEmpty
                  ? farmer.name[0]
                  .toUpperCase()
                  : 'F',
              style:
              const TextStyle(
                color:
                Color(0xFF287A32),
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  farmer.name,
                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  farmer.mobile,
                  style:
                  const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Last login: ${formatDate(farmer.lastLogin)}',
                  style:
                  const TextStyle(
                    fontSize: 11,
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

  Widget bookingCard(
      FarmerBooking booking,
      ) {
    final completed =
        booking.completedCount;

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),
      padding:
      const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          const Color(0xFFE0E7E0),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 12,
            offset:
            const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration:
                BoxDecoration(
                  color:
                  const Color(0xFFE7F4E8),
                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),
                child: Text(
                  booking.token,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF287A32),
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$completed/5',
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            booking.farmerName,
            style:
            const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            booking.farmerMobile,
            style:
            const TextStyle(
              color: Colors.black54,
            ),
          ),
          const Divider(height: 24),
          _detail(
            'Crop',
            booking.crop,
          ),
          _detail(
            'Quantity',
            '${booking.quantity} kg',
          ),
          _detail(
            'Date',
            booking.date,
          ),
          _detail(
            'Time',
            booking.time,
          ),
          const SizedBox(height: 12),
          const Text(
            'Process Status',
            style:
            TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            procurementSteps.length,
                (index) {
              final done =
              booking.completedSteps[
              index];

              return ListTile(
                contentPadding:
                EdgeInsets.zero,
                dense: true,
                leading: Icon(
                  done
                      ? Icons
                      .check_circle
                      : Icons
                      .radio_button_unchecked,
                  color: done
                      ? const Color(
                    0xFF287A32,
                  )
                      : Colors.grey,
                ),
                title: Text(
                  procurementSteps[
                  index],
                ),
                trailing: done
                    ? const Text(
                  'Completed',
                  style:
                  TextStyle(
                    color:
                    Color(
                      0xFF287A32,
                    ),
                    fontWeight:
                    FontWeight.bold,
                  ),
                )
                    : FilledButton.tonal(
                  onPressed: () =>
                      updateProcessStep(
                        booking:
                        booking,
                        stepIndex:
                        index,
                      ),
                  child:
                  const Text(
                    'Update',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: () =>
                sendFiveQueueUpdate(
                  booking,
                ),
            icon: const Icon(
              Icons.notifications_active_outlined,
            ),
            label: const Text(
              'Notify 5-Queue Farmer',
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(
      String label,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 6,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style:
              const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Employee Dashboard',
          style:
          TextStyle(
            fontWeight:
            FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () async {
              await data.loadData();
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: logout,
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: data.loadData,
        child: ListView(
          padding:
          const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            30,
          ),
          children: [
            Container(
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF287A32),
                    Color(0xFF3E9148),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(
                  24,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white24,
                      borderRadius:
                      BorderRadius.circular(
                        17,
                      ),
                    ),
                    child: const Icon(
                      Icons
                          .badge_rounded,
                      color:
                      Colors.white,
                      size: 31,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        const Text(
                          'Employee Portal',
                          style:
                          TextStyle(
                            color:
                            Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.employeeId,
                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize: 20,
                            fontWeight:
                            FontWeight.w900,
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
                  icon:
                  Icons.people_alt_outlined,
                  title:
                  'Farmers',
                  value:
                  data.farmers.length
                      .toString(),
                ),
                const SizedBox(width: 10),
                statCard(
                  icon:
                  Icons.receipt_long_outlined,
                  title:
                  'Bookings',
                  value:
                  data.bookings.length
                      .toString(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                statCard(
                  icon:
                  Icons.event_available_outlined,
                  title:
                  'Available',
                  value:
                  data.availableSlots
                      .toString(),
                ),
                const SizedBox(width: 10),
                statCard(
                  icon:
                  Icons.task_alt_outlined,
                  title:
                  'Completed',
                  value: data.bookings
                      .where(
                        (booking) =>
                    booking
                        .isCompleted,
                  )
                      .length
                      .toString(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Booked Customers',
              style:
              TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            if (data.bookings.isEmpty)
              _emptyCard(
                icon:
                Icons.inbox_outlined,
                title:
                'No bookings yet',
                subtitle:
                'Farmer bookings will appear here.',
              )
            else
              ...data.bookings.map(
                bookingCard,
              ),
            const SizedBox(height: 20),
            const Text(
              'Registered Farmers',
              style:
              TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            if (data.farmers.isEmpty)
              _emptyCard(
                icon:
                Icons.people_outline,
                title:
                'No farmers registered',
                subtitle:
                'Farmers will appear after login.',
              )
            else
              ...data.farmers.map(
                farmerCard,
              ),
            const SizedBox(height: 22),
            const Text(
              'Crop Management',
              style:
              TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
              const EdgeInsets.all(16),
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(
                  18,
                ),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...data.crops.map(
                        (crop) => Chip(
                      label: Text(crop),
                      deleteIcon:
                      const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onDeleted:
                      data.crops.length >
                          1
                          ? () =>
                          removeCrop(
                            crop,
                          )
                          : null,
                    ),
                  ),
                  ActionChip(
                    avatar:
                    const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label:
                    const Text(
                      'Add Crop',
                    ),
                    onPressed: addCrop,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: updateSlots,
                icon: const Icon(
                  Icons.settings_outlined,
                ),
                label: Text(
                  'Total Slots: ${data.totalSlots}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding:
      const EdgeInsets.all(24),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 42,
            color:
            const Color(0xFF287A32),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}