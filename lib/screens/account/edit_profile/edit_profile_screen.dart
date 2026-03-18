import 'package:flutter/material.dart';

import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/buttons/submit_button.dart';
import '../../../widgets/input_fields/f_name.dart';
import '../../../widgets/input_fields/l_name.dart';
import '../../../widgets/input_fields/email.dart';
import '../../../widgets/input_fields/mobile_number.dart';
import '../../../widgets/input_fields/address_input.dart';

import '../../home/widgets/nav_bar.dart';
import '../../search/search_screen.dart';
import '../../explore/explore_screen.dart';
import '../account_screen.dart';
import 'edit_profile_screen_changes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../merchant/merchant_home/merchant_home.dart';
import '../../merchant/merchant_home/widgets/merchant_nav_bar.dart';
import '../../../services/database_service.dart';
import '../../merchant/orders/orders.dart';
import '../../merchant/merchant_activity/activities/activities.dart';
import '../../merchant/dashboard/dashboard.dart';


class EditProfileScreen extends StatefulWidget {
  final String role;
  const EditProfileScreen({super.key, this.role = "Customer"});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(text: "");

  int _selectedIndex = 4; // Account tab
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
    if (firstName == null || firstName.isEmpty || firstName == "Merchant") {
      debugPrint("EditProfileScreen: Name is missing or default, triggering sync...");
      await DatabaseService().syncUserProfileToPreferences(role: widget.role);
    }

    if (mounted) {
      setState(() {
        _firstNameController.text = prefs.getString('firstName') ?? "";
        _lastNameController.text = prefs.getString('lastName') ?? "";
        _phoneController.text = (prefs.getString('mobileNumber') ?? "").replaceFirst('+94', '');
        _emailController.text = prefs.getString('email') ?? "";
        _addressController.text = prefs.getString('address') ?? "";
        
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
            MaterialPageRoute(builder: (context) => MerchantHomeScreen()),
            (route) => false,
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
          );
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else if (index == 4) {
          Navigator.pop(context);
        }
      } else {
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
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
        }
      }
      
      if (mounted) {
        setState(() {
          _selectedIndex = index;
        });
      }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button and Title
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Row(
                children: [
                   CustomBackButton(
                    onTap: () {
                       Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
             const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Profile Image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _profileImage != null
                              ? FileImage(_profileImage!) as ImageProvider
                              : const AssetImage("assets/images/profile1.png"), 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // First Name / Outlet Name
                    Text(
                      widget.role == "Merchant" ? "Outlet Name" : "First Name",
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF2D2D3A),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    FirstNameInput(
                      controller: _firstNameController, 
                      readOnly: true,
                      hintText: widget.role == "Merchant" ? "Outlet Name" : "First Name",
                    ),
                    
                    if (widget.role != "Merchant") ...[
                      const SizedBox(height: 16),
                      // Last Name
                       const Text(
                        "Last Name",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: Color(0xFF2D2D3A),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8),
                      LastNameInput(controller: _lastNameController, readOnly: true),
                    ],

                    const SizedBox(height: 16),

                     // Phone Number
                     const Text(
                      "Phone Number",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF2D2D3A),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    MobileNumberInput(controller: _phoneController, readOnly: true),

                     const SizedBox(height: 16),

                     // Email
                     const Text(
                      "Email",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF2D2D3A),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    EmailInput(controller: _emailController, readOnly: true),

                    const SizedBox(height: 16),
                    
                    // Address
                     const Text(
                      "Address",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF2D2D3A),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    AddressInput(controller: _addressController, readOnly: true),

                    const SizedBox(height: 40),

                    _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : SubmitButton(
                          text: "Edit Profile",
                          onTap: () async {
                             final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfileScreenChanges(role: widget.role)),
                            );
                            
                            if (result == true) {
                              _loadUserDetails(); // Reload if changes were saved
                            }
                          },
                        ),
                    const SizedBox(height: 20),
                  ],
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
