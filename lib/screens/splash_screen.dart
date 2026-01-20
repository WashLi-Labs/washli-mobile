import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/primary_button.dart';
import '../constants/app_constants.dart';
import 'logins/login_screen.dart';

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
              Color(0xFFB3E5FC),
              Color(0xFF7DB2DD),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Main Content
              Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.paddingMedium,
                  right: AppConstants.paddingXLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Elevate Your\nLaundry Routine',
                      textAlign: TextAlign.left,
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    // Subtitle
                    Text(
                      'Effortless Care And Sparking Results!',
                      textAlign: TextAlign.left,
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
                      onPressed: () {
                        // Navigate to LoginScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Image Section
              Expanded(
                flex: 4,
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
              
              // Copyright/Version Text
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingSmall,
                ),
                child: Text(
                  '© 2026 Washli • Version 1.0.0',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textPrimary.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
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
