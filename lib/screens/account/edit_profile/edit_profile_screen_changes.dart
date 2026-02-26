import 'package:flutter/material.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/buttons/cancel_button.dart';
import '../../../widgets/buttons/save_changes_button.dart';
import '../../../widgets/input_fields/f_name.dart';
import '../../../widgets/input_fields/l_name.dart';
import '../../../widgets/input_fields/email.dart';
import '../../../widgets/input_fields/mobile_number.dart';
import '../../../widgets/input_fields/address_input.dart';
import '../../home/widgets/nav_bar.dart';
import '../../search/search_screen.dart';
import '../../explore/explore_screen.dart';
import '../account_screen.dart';
import '../account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreenChanges extends StatefulWidget {
  const EditProfileScreenChanges({super.key});

  @override
  State<EditProfileScreenChanges> createState() => _EditProfileScreenChangesState();
}

class _EditProfileScreenChangesState extends State<EditProfileScreenChanges> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController(); 
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(text: "");

  int _selectedIndex = 4; 
  
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
                              image: AssetImage("assets/images/profile1.png"), 
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

                    // Cancel and Save Changes Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CancelButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SaveChangesButton(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('firstName', _firstNameController.text.trim());
                              await prefs.setString('lastName', _lastNameController.text.trim());
                              // Re-add +94 prefix for mobile number if not present
                              String phone = _phoneController.text.trim();
                              if (!phone.startsWith('+94')) {
                                phone = '+94$phone';
                              }
                              await prefs.setString('mobileNumber', phone);
                              await prefs.setString('email', _emailController.text.trim());
                              await prefs.setString('address', _addressController.text.trim());
                              
                              if (context.mounted) {
                                Navigator.pop(context, true); // Pass true to signal a refresh
                              }
                            },
                          ),
                        ),
                      ],
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
