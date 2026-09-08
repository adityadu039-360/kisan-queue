import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedCrop = 'Wheat';
  String selectedCentre = 'Government Procurement Centre';
  String? selectedTimeSlot;

  final TextEditingController quantityController =
  TextEditingController();

  DateTime selectedDate = DateTime.now();

  final List<String> crops = [
    'Wheat',
    'Rice',
    'Maize',
    'Cotton',
    'Soybean',
  ];

  final List<String> centres = [
    'Government Procurement Centre',
    'Kisan Seva Centre',
    'District Mandi Centre',
  ];

  final List<Map<String, String>> timeSlots = [
    {
      'time': '09:00 AM',
      'available': '12 slots available',
    },
    {
      'time': '10:00 AM',
      'available': '8 slots available',
    },
    {
      'time': '11:00 AM',
      'available': '15 slots available',
    },
    {
      'time': '12:00 PM',
      'available': '6 slots available',
    },
    {
      'time': '02:00 PM',
      'available': '10 slots available',
    },
    {
      'time': '03:00 PM',
      'available': '18 slots available',
    },
  ];

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final today = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void confirmBooking() {
    if (quantityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the quantity.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm Booking',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please confirm your procurement slot:',
              ),
              const SizedBox(height: 16),
              Text('Crop: $selectedCrop'),
              Text('Quantity: ${quantityController.text} kg'),
              Text('Centre: $selectedCentre'),
              Text('Date: ${formatDate(selectedDate)}'),
              Text('Time: $selectedTimeSlot'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pop(
                  this.context,
                  {
                    'token': 'KQ-104',
                    'crop': selectedCrop,
                    'quantity': quantityController.text.trim(),
                    'centre': selectedCentre,
                    'date': formatDate(selectedDate),
                    'time': selectedTimeSlot!,
                  },
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
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
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F8F4),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book your slot',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172118),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Choose your crop, centre, date and preferred time.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF687268),
                ),
              ),

              const SizedBox(height: 24),

              // Crop
              const Text(
                'Crop',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedCrop,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.grass),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: crops.map((crop) {
                  return DropdownMenuItem(
                    value: crop,
                    child: Text(crop),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCrop = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Quantity
              const Text(
                'Quantity (kg)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  prefixIcon: const Icon(Icons.scale_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Centre
              const Text(
                'Procurement Centre',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedCentre,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: centres.map((centre) {
                  return DropdownMenuItem(
                    value: centre,
                    child: Text(
                      centre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCentre = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Date
              const Text(
                'Preferred Date',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: selectDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF287A32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          formatDate(selectedDate),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Time slots
              const Text(
                'Select Time Slot',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              ...timeSlots.map((slot) {
                final time = slot['time']!;
                final available = slot['available']!;
                final isSelected = selectedTimeSlot == time;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeSlot = time;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE5F5E7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF287A32)
                            : const Color(0xFFE0E5E0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? const Color(0xFF287A32)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                available,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF687268),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.schedule_outlined,
                          color: Color(0xFF287A32),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Booking summary
              if (selectedTimeSlot != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Crop: $selectedCrop'),
                      Text(
                        'Quantity: ${quantityController.text.isEmpty ? '--' : quantityController.text} kg',
                      ),
                      Text('Centre: $selectedCentre'),
                      Text('Date: ${formatDate(selectedDate)}'),
                      Text('Time: $selectedTimeSlot'),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: confirmBooking,
                  icon: const Icon(
                    Icons.confirmation_number_outlined,
                  ),
                  label: const Text(
                    'Confirm & Get Token',
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
}