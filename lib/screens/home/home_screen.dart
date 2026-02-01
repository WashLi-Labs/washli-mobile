import 'package:flutter/material.dart';
import 'widgets/action_card.dart';
import 'widgets/category_list.dart';
import 'widgets/home_header.dart';
import 'widgets/nearby_laundry_card.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    super.key,
    this.userName = "James",
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                HomeHeader(userName: widget.userName),
                
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
            
            // Action Card Positioning
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45 - 50, // Half in, half out
              left: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.85)) / 2, // Centered
              child: const ActionCard(),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar Placeholder for completeness (Optional based on screenshot)
      extendBody: true, // Allows body to extend behind the floating navbar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(0),
         decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem("assets/icons/Home Page-1.png", "Home", 0),
            _buildNavItem("assets/icons/Search-1.png", "Search", 1),
            _buildNavItem("assets/icons/explore-1.png", "Explore", 2),
            _buildNavItem("assets/icons/Shopping Cart-1.png", "Cart", 3),
             _buildNavItem("assets/icons/Account.png", "Account", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            assetPath,
            width: 24,
            height: 24,
            color: isActive ? Colors.black : Colors.grey,
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
          else
             // Invisible placeholder to keep height consistent
             Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 2,
              color: Colors.transparent,
            )
        ],
      ),
    );
  }
}
