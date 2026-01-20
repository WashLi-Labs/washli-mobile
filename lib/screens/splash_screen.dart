import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/primary_button.dart';
import '../constants/app_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashBackground,
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingXLarge,
                ),
                child: Column(
                  children: [
                    // Title
                    Text(
                      'Elevate Your\nLaundry Routine',
                      textAlign: TextAlign.left,
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    // Subtitle
                    Text(
                      'Effortless Care And Sparking Results!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 16,
                        color: AppColors.textPrimary.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingXLarge),
                    
                    // Get Started Button
                    PrimaryButton(
                      text: 'Get Started',
                      icon: Icons.arrow_forward,
                      width: double.infinity,
                      onPressed: () {
                        // TODO: Navigate to next screen
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => NextScreen()),
                        // );
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Image Section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppConstants.splashBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
