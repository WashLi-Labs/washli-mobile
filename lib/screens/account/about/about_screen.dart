import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../widgets/buttons/back_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                children: [
                  CustomBackButton(
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'About',
                    style: AppTextStyles.heading,
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'WashLi',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Smart laundry solutions for a faster and easier lifestyle.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    Text(
                      'About WashLi',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBodyText(
                      'WashLi is a smart laundry service platform developed to simplify the way people manage their laundry needs. The application enables users to find nearby laundry providers, schedule pickups and deliveries, track their orders in real time, and receive smart reminders through an easy-to-use digital platform.',
                    ),
                    const SizedBox(height: 16),
                    _buildBodyText(
                      'WashLi was created to support busy individuals who need a more convenient and efficient way to handle their daily laundry tasks. By combining service accessibility with modern technology, the application helps users save time while improving the overall laundry experience.',
                    ),
                    const SizedBox(height: 30),
                    
                    Text(
                      'Our Mission',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBodyText(
                      'Our mission is to make laundry services more accessible, reliable, and user-friendly through digital innovation. We aim to reduce the inconvenience of traditional laundry processes by offering a smarter and more connected solution.',
                    ),
                    const SizedBox(height: 30),

                    Text(
                      'Features',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBodyText(
                      'WashLi provides several useful features, including laundry finder, automated pickup and delivery, delivery time prediction, order tracking, AI Fabric Advisor, flexible scheduling, and reward-based user credits. These features are designed to improve convenience, support better clothing care, and create a more efficient service experience for users.',
                    ),
                    const SizedBox(height: 16),
                    _buildBodyText(
                      'We believe that technology can transform everyday services into simpler and more effective solutions. Therefore, WashLi is designed not only as a laundry booking application, but also as a smart assistant that helps users manage their laundry with confidence.',
                    ),
                    const SizedBox(height: 30),

                    Text(
                      'Our Vision',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBodyText(
                      'Our vision is to become a trusted and innovative digital laundry platform that delivers convenience, reliability, and quality service for modern lifestyles.',
                    ),
                    const SizedBox(height: 30),

                    Text(
                      'Get in Touch',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBodyText(
                      'For further assistance, users can visit the Help & Support section or contact the WashLi support team directly through the app.',
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Version 1.0.0',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '© 2026 WashLi. All rights reserved.',
                            style: AppTextStyles.caption,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: AppTextStyles.body,
    );
  }
}
