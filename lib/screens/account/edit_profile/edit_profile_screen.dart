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


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

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
  
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
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
    });
  }

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
          // Already in Account section, maybe pop back to main account screen? 
          // For now, let's just go back to AccountScreen
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountScreen()),
          );
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

                    // First Name
                    const Text(
                      "First Name",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF2D2D3A),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    FirstNameInput(controller: _firstNameController, readOnly: true),
                    
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
                    // Assuming LastNameInput exists or using FirstNameInput logic
                    LastNameInput(controller: _lastNameController, readOnly: true),

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

                    SubmitButton(
                      text: "Edit Profile",
                      onTap: () async {
                         final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreenChanges()),
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
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
