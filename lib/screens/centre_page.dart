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
          'Procurement Centres',
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
                'Nearby Centres',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172118),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Check queue status and available procurement slots.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF687268),
                ),
              ),
              const SizedBox(height: 24),

              _centreCard(
                context: context,
                name: 'Government Procurement Centre',
                distance: '2.4 km away',
                queue: '13 farmers',
                slots: '18 slots',
                wait: '45 min',
                isOpen: true,
              ),

              _centreCard(
                context: context,
                name: 'Kisan Seva Centre',
                distance: '4.1 km away',
                queue: '8 farmers',
                slots: '24 slots',
                wait: '30 min',
                isOpen: true,
              ),

              _centreCard(
                context: context,
                name: 'District Mandi Centre',
                distance: '7.8 km away',
                queue: '21 farmers',
                slots: '6 slots',
                wait: '70 min',
                isOpen: true,
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF287A32),
                      size: 26,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Tip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF172118),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Choose a centre with fewer farmers ahead to reduce waiting time.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF526052),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centreCard({
    required BuildContext context,
    required String name,
    required String distance,
    required String queue,
    required String slots,
    required String wait,
    required bool isOpen,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF287A32),
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172118),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      distance,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF687268),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isOpen
                      ? const Color(0xFFEAF5EB)
                      : const Color(0xFFFDECEC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOpen ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isOpen
                        ? const Color(0xFF287A32)
                        : Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _infoItem(
                  Icons.people_outline,
                  queue,
                  'Queue',
                ),
              ),
              Expanded(
                child: _infoItem(
                  Icons.event_available_outlined,
                  slots,
                  'Available',
                ),
              ),
              Expanded(
                child: _infoItem(
                  Icons.timer_outlined,
                  wait,
                  'Wait',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onBookSlot,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF287A32),
                side: const BorderSide(
                  color: Color(0xFF287A32),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Book Slot Here',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String value,
      String label,
      ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF287A32),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172118),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF687268),
          ),
        ),
      ],
    );
  }
}