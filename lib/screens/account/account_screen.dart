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
import '../merchant/merchant_home/widgets/merchant_nav_bar.dart';
import '../merchant/orders/orders.dart';
import '../merchant/merchant_activity/activities/activities.dart';
import '../merchant/dashboard/dashboard.dart';
import '../merchant/merchant_home/merchant_home.dart';
import '../../services/firebase/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  final String role;
  const AccountScreen({super.key, this.role = "Customer"});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  int _selectedIndex = 4;
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  File? _profileImage;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    
    final prefs = await SharedPreferences.getInstance();
    
    // If name is missing or empty, try to sync from Firestore first
    String? firstName = prefs.getString('firstName');
    if (firstName == null || firstName.isEmpty || firstName == "Merchant" || firstName == "Sam") {
      debugPrint("AccountScreen: Name is missing or default, triggering sync...");
      await DatabaseService().syncUserProfileToPreferences(role: widget.role);
    }

    if (mounted) {
      final fName = prefs.getString('firstName') ?? (widget.role == "Merchant" ? "Merchant" : "Sam");
      final lName = prefs.getString('lastName') ?? (widget.role == "Merchant" ? "" : "William");
      final mail = prefs.getString('email') ?? (widget.role == "Merchant" ? "merchant@email.com" : "sam@email.com");
      final fullName = lName.isNotEmpty ? "$fName $lName" : fName;
      
      // Sync to Riverpod Provider
      ref.read(userProvider.notifier).login(
        uid: prefs.getString('uid') ?? "local",
        name: fullName,
        email: mail,
      );

      setState(() {
        String? imagePath = prefs.getString('profileImagePath');
        if (imagePath != null && imagePath.isNotEmpty) {
          _profileImage = File(imagePath);
        }
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
      if (widget.role == "Merchant") {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MerchantHomeScreen()),
            (route) => false,
          );
        } else if (index == 1) {
          // Navigate to Merchant Orders
          // For now, push and reset index when back
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          ).then((_) => setState(() => _selectedIndex = 4));
        } else if (index == 2) {
          // Navigate to Merchant Activities
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
          ).then((_) => setState(() => _selectedIndex = 4));
        } else if (index == 3) {
          // Navigate to Dashboard
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          ).then((_) => setState(() => _selectedIndex = 4));
        } else if (index == 4) {
          // Already on Account
        }
      } else {
        // Customer Navigation
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
      }
      
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    
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
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ProfileCard(
                            name: user.name ?? "Loading...",
                            email: user.email ?? "Loading...",
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
                                MaterialPageRoute(builder: (context) => EditProfileScreen(role: widget.role)),
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
                          if (widget.role == "Customer")
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
      bottomNavigationBar: widget.role == "Merchant" 
        ? MerchantNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          )
        : NavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
    );
  }
}
