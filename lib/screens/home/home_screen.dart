import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            _buildNavItem("assets/home-icons/Home Angle.svg", "Home", 0),
            _buildNavItem("assets/home-icons/Magnifer.svg", "Search", 1),
            _buildNavItem("assets/home-icons/Global.svg", "Explore", 2),
            _buildNavItem("assets/home-icons/Bag 2.svg", "Cart", 3),
             _buildNavItem("assets/home-icons/Account.svg", "Account", 4),
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
          SvgPicture.asset(
            assetPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? Colors.black : Colors.grey,
              BlendMode.srcIn,
            ),
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
