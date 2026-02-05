import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/input_fields/custom_search_bar.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> laundry;

  const ShopDetailsScreen({super.key, required this.laundry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image and Back Button
            Stack(
              children: [
                Image.asset(
                  laundry['image'] ?? 'assets/images/laundry shop.png',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: CustomBackButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'More Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    laundry['status'] ?? "Open", // Default to Open if null, or handle logic
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
                  
                  const SizedBox(height: 24),
                  
                  // Search Bar
                  const CustomSearchBar(
                    hintText: 'Search',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Services Header
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Services List
                  _buildServiceItem(
                    "Just Wash It", 
                    "LKR 400.00", 
                    "Fragrant wash, but not ironed", 
                    "assets/images/laundry 1.png"
                  ),
                  _buildServiceItem(
                    "wash and Iron", 
                    "LKR 400.00", 
                    "Fragrant wash, and ironed", 
                    "assets/images/laundry 1.png"
                  ),
                  _buildServiceItem(
                    "Carpet", 
                    "LKR 400.00", 
                    "Let it be comfortable take it easy", 
                    "assets/images/laundry shop.png"
                  ),
                   _buildServiceItem(
                    "Dry Cleaning", 
                    "LKR 400.00", 
                    "Suits, Dresses and kinda clean!", 
                    "assets/images/laundry 1.png"
                  ),
                   _buildServiceItem(
                    "Carpet", 
                    "LKR 400.00", 
                    "Let it be comfortable take it easy", 
                    "assets/images/laundry shop.png"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildServiceItem(String title, String price, String description, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF), // Blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(60, 30),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Add",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Fee : $price",
                   style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                     color: Color(0xFF2D2D3A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
