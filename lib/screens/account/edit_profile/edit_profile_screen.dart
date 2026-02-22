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


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController(text: " Ranjith");
  final TextEditingController _lastNameController = TextEditingController(text: " Perera"); // Assuming Last Name Controller exists, if not I'll just use First Name style or Generic
  final TextEditingController _phoneController = TextEditingController(text: " +9476756990");
  final TextEditingController _emailController = TextEditingController(text: " ranjithperera@gmail.com");
  final TextEditingController _addressController = TextEditingController(text: " No 07,High Level Road,Nugegoda");

  int _selectedIndex = 4; // Account tab

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
                    // Profile Image with Camera Icon
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("assets/images/profile1.png"), // Using existing asset
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F1FF), // Light blue
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFF0057FF),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
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
                    FirstNameInput(controller: _firstNameController),
                    
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
                    LastNameInput(controller: _lastNameController),

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
                    MobileNumberInput(controller: _phoneController),

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
                    EmailInput(controller: _emailController),

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
                    AddressInput(controller: _addressController),

                    const SizedBox(height: 40),

                    // Edit Profile Button
                    SubmitButton(
                      text: "Edit Profile",
                      onTap: () {
                         // Implement save logic here
                         Navigator.pop(context);
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
