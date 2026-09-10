import 'package:flutter/material.dart';

import '../services/farmer_data.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final quantityController = TextEditingController();

  String? selectedCrop;
  String selectedDate = 'Today';
  String selectedTime = '09:00 AM - 10:00 AM';

  final List<String> dates = [
    'Today',
    'Tomorrow',
    'Day After Tomorrow',
  ];

  final List<String> timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
  ];

  FarmerDataService get data => FarmerDataService.instance;

  @override
  void initState() {
    super.initState();

    if (data.crops.isNotEmpty) {
      selectedCrop = data.crops.first;
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void confirmBooking() {
    if (selectedCrop == null) {
      showMessage('Please select a crop.');
      return;
    }

    final quantity = quantityController.text.trim();

    if (quantity.isEmpty) {
      showMessage('Please enter quantity.');
      return;
    }

    final parsedQuantity = int.tryParse(quantity);

    if (parsedQuantity == null || parsedQuantity <= 0) {
      showMessage('Please enter a valid quantity.');
      return;
    }

    if (data.availableSlots <= 0) {
      showMessage(
        'No procurement slots are currently available.',
      );
      return;
    }

    final token = data.nextToken();

    Navigator.pop(
      context,
      {
        'token': token,
        'crop': selectedCrop!,
        'quantity': quantity,
        'centre': 'Government Procurement Centre',
        'date': selectedDate,
        'time': selectedTime,
      },
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF172118),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F4),
      appBar: AppBar(
        title: const Text(
          'Book Procurement Slot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF287A32),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 34,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Government Procurement Centre',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${data.availableSlots} slots available',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle('Select Crop'),

            DropdownButtonFormField<String>(
              value: selectedCrop,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.grass_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: data.crops.map((crop) {
                return DropdownMenuItem<String>(
                  value: crop,
                  child: Text(crop),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCrop = value;
                });
              },
            ),

            const SizedBox(height: 20),

            sectionTitle('Quantity'),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity in kilograms',
                prefixIcon: Icon(Icons.scale_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            sectionTitle('Select Date'),

            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: dates.map((date) {
                  return RadioListTile<String>(
                    value: date,
                    groupValue: selectedDate,
                    title: Text(date),
                    activeColor: const Color(0xFF287A32),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        selectedDate = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            sectionTitle('Select Time Slot'),

            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: timeSlots.map((time) {
                  return RadioListTile<String>(
                    value: time,
                    groupValue: selectedTime,
                    title: Text(time),
                    activeColor: const Color(0xFF287A32),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        selectedTime = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: confirmBooking,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}