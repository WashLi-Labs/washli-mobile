import 'package:flutter/material.dart';
import 'widgets/action_card.dart';
import 'widgets/category_list.dart';
import 'widgets/home_header.dart';
import 'widgets/nearby_laundry_card.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({
    super.key,
    this.userName = "James",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                HomeHeader(userName: userName),
                
                // Spacing for Action Card intersection
                const SizedBox(height: 60), 
                
                // Categories
                const CategoryList(),
                
                const SizedBox(height: 30),
                
                // Nearby Laundries
                const NearbyLaundryCard(),
                
                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
          
          // Action Card Positioning
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45 - 50, // Half in, half out
            left: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.85)) / 2, // Centered
            child: const ActionCard(),
          ),
        ],
      ),
      
      // Bottom Navigation Bar Placeholder for completeness (Optional based on screenshot)
      bottomNavigationBar: Container(
         decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, "Home", true),
            _buildNavItem(Icons.search, "Search", false),
            _buildNavItem(Icons.shopping_basket_outlined, "Cart", false),
             _buildNavItem(Icons.person_outline, "Profile", false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.black : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 20,
            height: 2,
            color: Colors.black,
          )
      ],
    );
  }
}
