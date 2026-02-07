import 'package:flutter/material.dart';
import 'package:washli_mobile/widgets/buttons/more_info.dart';

class ShopHeader extends StatelessWidget {
  final Map<String, dynamic> laundry;

  const ShopHeader({super.key, required this.laundry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Image
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                laundry['image'] ?? 'assets/images/laundry shop.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: -15,
              right: 16,
              child: MoreInfoButton(
                  onTap: () {
                    // unexpected behavior
                  },
                ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status
              if (laundry['status'] != null)
                Text(
                  laundry['status'] ?? "Open",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D2D3A),
                  ),
                ),
              const SizedBox(height: 4),

              // Title
              Text(
                laundry['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              const SizedBox(height: 16),

              // Delivery & Fee Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildIconText(Icons.local_shipping_outlined, "Delivery"),
                      const SizedBox(width: 16),
                      _buildIconText(Icons.directions_walk, "Self Pickup"),
                    ],
                  ),
                  Text(
                    'Fee : ${laundry['fee']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Est Time Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Est : 50 mins', // Could be dynamic
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
