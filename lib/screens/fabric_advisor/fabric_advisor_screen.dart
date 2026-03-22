import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/upload_button.dart';
import '../../widgets/buttons/submit_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/fabric_advisor_provider.dart';
import 'widgets/fabric_prediction_result_view.dart';

class FabricAdvisorScreen extends ConsumerStatefulWidget {
  const FabricAdvisorScreen({super.key});

  @override
  ConsumerState<FabricAdvisorScreen> createState() => _FabricAdvisorScreenState();
}

class _FabricAdvisorScreenState extends ConsumerState<FabricAdvisorScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Optionally reset previous results if image changes
      ref.read(fabricAdvisorProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final advisorState = ref.watch(fabricAdvisorProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
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
                        style: AppTypography.heading1,
                      ),
                      
                      const SizedBox(height: 24),
      
                      // Camera Area
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBlueLight,
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
                                        AppColors.primaryBlue,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Take a photo of item',
                                      style: AppTypography.body,
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
                                          ref.read(fabricAdvisorProvider.notifier).reset();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: AppColors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: AppColors.error,
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
                      
                      // Description Text Area
                      TextField(
                        controller: _descriptionController,
                        maxLength: 50,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add description (Optional)',
                          hintStyle: AppTypography.body,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primaryBlue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      SubmitButton(
                        isEnabled: _image != null && !advisorState.isLoading,
                        onTap: () {
                          if (_image == null) return;
                          ref.read(fabricAdvisorProvider.notifier).predict(
                            _image!,
                            _descriptionController.text,
                          );
                        },
                        text: advisorState.isLoading ? 'Predicting...' : 'Submit',
                      ),
      
                      const SizedBox(height: 32),
      
                      // AI Detection Result
                      const Text(
                        'AI Detection Result',
                        style: AppTypography.heading2,
                      ),
                      const SizedBox(height: 16),
                      
                      if (advisorState.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        
                      if (advisorState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            advisorState.errorMessage!,
                            style: AppTypography.body.copyWith(color: AppColors.error),
                          ),
                        ),
                        
                      if (advisorState.prediction != null)
                        FabricPredictionResultView(prediction: advisorState.prediction!),
                        
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
}
