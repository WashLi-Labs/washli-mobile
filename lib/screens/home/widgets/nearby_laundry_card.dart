import 'package:flutter/material.dart';

class NearbyLaundryCard extends StatelessWidget {
  const NearbyLaundryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Laundries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
             decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD).withOpacity(0.4), // Very light blue background
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Wijerama Laundry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No.07, Wijerama Junction, Nugegoda',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                       const SizedBox(height: 2),
                       Text(
                        '3km away',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                 Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/shop1.jpg',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
