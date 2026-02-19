import 'package:flutter/material.dart';
import 'widgets/action_card.dart';
import 'widgets/category_list.dart';
import 'widgets/home_header.dart';
import 'widgets/nav_bar.dart';
import 'widgets/nearby_laundry_card.dart';
import '../search/search_screen.dart';
import '../explore/explore_screen.dart';
import '../account/account_screen.dart';
import '../payment/payment_screen.dart';
import '../cart/cart_screen.dart';

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
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExploreScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else {
        setState(() {
            _selectedIndex = index;
        });
    }
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
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

}
