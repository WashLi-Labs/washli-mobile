import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/upload_button.dart';
import '../../widgets/buttons/submit_button.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FabricAdvisorScreen extends StatefulWidget {
  const FabricAdvisorScreen({super.key});

  @override
  State<FabricAdvisorScreen> createState() => _FabricAdvisorScreenState();
}

class _FabricAdvisorScreenState extends State<FabricAdvisorScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Fixed Back Button Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Title (Scrolls with content)
                      const SizedBox(height: 10),
                      const Text(
                        'AI Fabric Advisor',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
      
                      // Camera Area
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE), // Light blueish background
                            borderRadius: BorderRadius.circular(20),
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/camera.svg',
                                      width: 60,
                                      height: 60,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF4285F4), // Blue icon color
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Take a photo of item',
                                      style: TextStyle(
                                        color: Color(0xFF5F6368),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _image = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
      
                      const SizedBox(height: 24),
      
                      // Buttons
                      UploadButton(
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                      const SizedBox(height: 16),
                      SubmitButton(
                        isEnabled: _image != null,
                        onTap: () {
                          // Handle submit
                        },
                        text: 'Submit',
                      ),
      
                      const SizedBox(height: 32),
      
                      // AI Detection Result
                      const Text(
                        'AI Detection Result',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F4), // Light grey background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildResultRow('Fabric Type'),
                            const SizedBox(height: 12),
                            _buildResultRow('Wash Type'),
                            const SizedBox(height: 12),
                            _buildResultRow('Wash Cycle'),
                            
                            const SizedBox(height: 24),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: null, // Disabled state visual
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  disabledBackgroundColor: const Color(0xFFD9D9D9),
                                   shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Use AI Suggestions',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF2D2D3A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
