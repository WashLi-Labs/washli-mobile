import 'package:flutter/material.dart';
import '../../widgets/input_fields/custom_search_bar.dart';
import '../../widgets/buttons/back_button.dart';
import '../home/widgets/nav_bar.dart';
import 'widgets/account_menu_item.dart';
import '../Auth/onboarding.dart';
import 'widgets/profile_card.dart';
import 'widgets/section_header.dart';
import '../search/search_screen.dart';
import '../explore/explore_screen.dart';
import '../payment/payment_screen.dart';
import 'edit_profile/edit_profile_screen.dart';
import '../cart/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../home/home_screen.dart';
import 'settings/settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 4;
  String _firstName = "Sam";
  String _lastName = "William";
  String _email = "sam@email.com";
  File? _profileImage;
  
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? "Sam";
      _lastName = prefs.getString('lastName') ?? "William";
      _email = prefs.getString('email') ?? "sam@email.com";
      
      String? imagePath = prefs.getString('profileImagePath');
      if (imagePath != null && imagePath.isNotEmpty) {
        _profileImage = File(imagePath);
      }
    });
  }

  void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
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
      } else if (index == 3) {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
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
            // Header with Back Button and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomBackButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24, // Increased size for prominence
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                      ProfileCard(
                        name: "$_firstName $_lastName",
                        email: _email,
                        imageProvider: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : const AssetImage("assets/images/profile1.png"),
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
                        onTap: () async {
                          // Wait for result from Edit Profile Flow
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          );
                          // Always reload after returning to ensure data is updated
                          _loadUserDetails();
                        },
                      ),
                      AccountMenuItem(
                        iconPath: "assets/icons/settings_blue.svg",
                        title: "Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      AccountMenuItem(
                        iconPath: "assets/icons/payments_blue.svg",
                        title: "Payments",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentScreen()),
                          );
                        },
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
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                        (route) => false,
                      );
                    }
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
