import 'package:flutter/material.dart';
import '../../widgets/input_fields/custom_search_bar.dart';
import '../../widgets/buttons/back_button.dart';
import '../home/widgets/nav_bar.dart';
import 'widgets/account_menu_item.dart';
import 'widgets/profile_card.dart';
import 'widgets/section_header.dart';
import '../search/search_screen.dart';
import '../explore/explore_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.popUntil(context, (route) => route.isFirst);
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      } else if (index == 2) {
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExploreScreen()),
        );
      } else if (index == 4) {
          // Already on Account
      }
      
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
             // Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onTap: () {
                     Navigator.pop(context);
                  },
                ),
              ),
            ),
            
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Outfit',
                    fontSize: 24, // Increased size for prominence
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const ProfileCard(
                        name: "Sam William",
                        email: "sam@email.com",
                        imagePath: "assets/images/shop1.jpg", 
                      ),
                      const SizedBox(height: 20),
                      const CustomSearchBar(
                        hintText: "Search for a Setting.....",
                      ),
                      const SizedBox(height: 20),
                      
                      const SectionHeader(title: "Account"),
                      AccountMenuItem(
                        iconPath: "assets/icons/profile_blue.svg",
                        title: "Profile",
                        onTap: () {},
                      ),
                      AccountMenuItem(
                        iconPath: "assets/icons/settings_blue.svg",
                        title: "Settings",
                        onTap: () {},
                      ),
                      AccountMenuItem(
                        iconPath: "assets/icons/payments_blue.svg",
                        title: "Payments",
                        onTap: () {},
                      ),
                      
                      const SizedBox(height: 20),
                      const SectionHeader(title: "Privacy & Support"),
                      AccountMenuItem(
                        iconPath: "assets/icons/privacy_blue.svg",
                        title: "Privacy Policy",
                        onTap: () {},
                      ),
                       AccountMenuItem(
                        iconPath: "assets/icons/help_blue.svg",
                        title: "Help & Support",
                        onTap: () {},
                      ),
                       AccountMenuItem(
                        iconPath: "assets/icons/about_blue.svg",
                        title: "About",
                        onTap: () {},
                      ),
        
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom aligned Logout Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logout logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0057E6), 
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
