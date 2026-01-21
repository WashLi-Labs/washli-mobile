import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../constants/app_constants.dart';
import 'new_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({
    super.key,
    this.email = 'gihan@gmail.com', // Default placeholder as per design image
  });

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  // Controllers for 5 OTP digits
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.length == 1 && index < 4) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    // If user pasted code or typed fast, logic could be more complex, but single digit simplified here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.paddingMedium),
              // Title
              Text(
                'Enter Code',
                style: AppTextStyles.displayLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              
              // Subtitle with Edit link
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a verification code to your email\n'),
                    TextSpan(
                      text: widget.email, // Using widget.email
                      style: const TextStyle(color: AppColors.textPrimary), // Darker for email
                    ),
                    const TextSpan(text: '  '), // Spacing
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: () {
                           Navigator.pop(context); // Go back to edit email
                        },
                        child: Text(
                          'Edit',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.loginButton, // Blue color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingXLarge),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.headlineMedium,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          borderSide: const BorderSide(color: AppColors.loginButton),
                        ),
                      ),
                      onChanged: (value) => _onOtpDigitChanged(index, value),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Resend Code
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Didn't receive any code? ",
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12), // Smaller text as per image
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement resend logic
                      },
                      child: Text(
                        'Resend code',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.loginButton,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue Button
              PrimaryButton(
                text: 'Continue',
                backgroundColor: AppColors.loginButton,
                 // borderRadius: AppConstants.radiusMedium, // Removed to match login button pill shape logic if applicable or keep customized?
                 // Checking previous interaction, user wanted "Login button need to be like this" -> Pill shape.
                 // So default pill shape logic is correct.
                 // Wait, design image for OTP screen shows rounded rect button similar to Login flow?
                 // The uploaded image 1768926308135.png shows a pill-shaped button (fully rounded ends).
                 // So I will use the default PrimaryButton which uses 30 radius (pill).
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewPasswordScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
