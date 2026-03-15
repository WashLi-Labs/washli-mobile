import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../services/database_service.dart';

class EditProfileScreenChanges extends StatefulWidget {
  const EditProfileScreenChanges({super.key});

  @override
  State<EditProfileScreenChanges> createState() =>
      _EditProfileScreenChangesState();
}

class _EditProfileScreenChangesState extends State<EditProfileScreenChanges> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(
    text: "",
  );

  int _selectedIndex = 4;
  File? _profileImage;
  String? _profileImageUrl;
  bool _isLoading = false;
  bool _pickedNewImage = false;
  final ImagePicker _picker = ImagePicker();

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
      _phoneController.text = (prefs.getString('mobileNumber') ?? "")
          .replaceFirst('+94', '');
      _emailController.text = prefs.getString('email') ?? "";
      _addressController.text = prefs.getString('address') ?? "";

      String? imagePath = prefs.getString('profileImagePath');
      if (imagePath != null && imagePath.isNotEmpty) {
        // Only load if file actually exists locally, else fallback to URL
        if (File(imagePath).existsSync()) {
          _profileImage = File(imagePath);
        }
      }
      _profileImageUrl = prefs.getString('profileImageUrl');
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _pickedNewImage = true;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerOptions() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Change Profile Picture'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text('Take a Photo'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Profile photo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    }
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _profileImage != null
                                  ? FileImage(_profileImage!) as ImageProvider
                                  : (_profileImageUrl != null &&
                                            _profileImageUrl!.isNotEmpty
                                        ? NetworkImage(_profileImageUrl!)
                                              as ImageProvider
                                        : const AssetImage(
                                            "assets/images/profile1.png",
                                          )),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F1FF), // Light blue
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Color(0xFF0057FF),
                                size: 20,
                              ),
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
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
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SaveChangesButton(
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                      'firstName',
                                      _firstNameController.text.trim(),
                                    );
                                    await prefs.setString(
                                      'lastName',
                                      _lastNameController.text.trim(),
                                    );
                                    // Re-add +94 prefix for mobile number if not present
                                    String phone = _phoneController.text.trim();
                                    if (!phone.startsWith('+94')) {
                                      phone = '+94$phone';
                                    }
                                    await prefs.setString(
                                      'mobileNumber',
                                      phone,
                                    );
                                    await prefs.setString(
                                      'email',
                                      _emailController.text.trim(),
                                    );
                                    await prefs.setString(
                                      'address',
                                      _addressController.text.trim(),
                                    );

                                    String? downloadUrl = _profileImageUrl;

                                    if (_profileImage != null) {
                                      await prefs.setString(
                                        'profileImagePath',
                                        _profileImage!.path,
                                      );

                                      if (_pickedNewImage) {
                                        // Upload to Firebase Storage only if a new image was picked
                                        downloadUrl = await DatabaseService()
                                            .uploadProfileImage(_profileImage!);
                                        if (downloadUrl != null) {
                                          await prefs.setString(
                                            'profileImageUrl',
                                            downloadUrl,
                                          );
                                        }
                                      }
                                    }

                                    try {
                                      await DatabaseService().updateUserDetails(
                                        firstName: _firstNameController.text
                                            .trim(),
                                        lastName: _lastNameController.text
                                            .trim(),
                                        email: _emailController.text.trim(),
                                        mobileNumber: phone,
                                        address: _addressController.text.trim(),
                                        profileImageUrl: downloadUrl,
                                      );
                                    } catch (e) {
                                      debugPrint(
                                        'Failed to update user profile in Firestore: $e',
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Failed to update details in Firestore',
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(
                                        context,
                                        true,
                                      ); // Pass true to signal a refresh
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
