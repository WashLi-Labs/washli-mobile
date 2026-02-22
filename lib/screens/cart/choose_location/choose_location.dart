import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// The Widget displayed on Cart Screen
class LocationSelector extends StatelessWidget {
  final String address;
  final String subAddress;
  final VoidCallback onTap;

  const LocationSelector({
    super.key,
    required this.address,
    required this.subAddress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEFF3), // Light blue-ish grey
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/location_pin.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF2D2D3A), // Dark text color
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    address,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  if (subAddress.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

// The Screen navigated to for choosing location
class ChooseLocationScreen extends StatelessWidget {
  const ChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Location')),
      body: const Center(child: Text('Map/Location selection will be here')),
    );
  }
}
