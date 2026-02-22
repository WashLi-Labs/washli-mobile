import 'package:flutter/material.dart';
import '../../explore/explore_screen.dart';

class NearbyLaundryCard extends StatelessWidget {
  const NearbyLaundryCard({super.key});

  final List<Map<String, String>> laundries = const [
    {
      'name': 'Wijerama Laundry',
      'address': 'No.07, Wijerama Junction, Nugegoda',
      'distance': '3km away',
      'image': 'assets/images/shop1.jpg',
    },
    {
      'name': 'Clean & Shine',
      'address': '12/A, High Level Road, Nugegoda',
      'distance': '1.2km away',
      'image': 'assets/images/shop1.jpg', // Placeholder
    },
    {
      'name': 'Quick Wash Hub',
      'address': 'No.45, Pagoda Road, Nugegoda',
      'distance': '2.5km away',
      'image': 'assets/images/shop1.jpg', // Placeholder
    },
    {
      'name': 'City Laundromat',
      'address': '88, Stanley Tilakaratne Mawatha',
      'distance': '0.8km away',
      'image': 'assets/images/shop1.jpg', // Placeholder
    },
  ];

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExploreScreen()),
                  );
                },
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...laundries.map((laundry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
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
                        Text(
                          laundry['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          laundry['address']!,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                         const SizedBox(height: 2),
                         Text(
                          laundry['distance']!,
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
                        laundry['image']!,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
