import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // Assuming white/surface background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppConstants.paddingMedium),
                      // Title
                      Text(
                        'Login',
                        style: AppTextStyles.displayLarge.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Text(
                        'Fill in the details to Login to your account',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingXLarge),

                      // Email Input
                      _buildLabel('Email'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Enter your Email Address',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Password Input
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Enter your Password',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingXLarge),

                      // Login Button
                      PrimaryButton(
                        text: 'Login',
                        backgroundColor: AppColors.loginButton,
                        onPressed: () {
                          // TODO: Implement login logic
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingMedium),

                      // Forgot Password
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Forgot your Password? ',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to forgot password
                              },
                              child: Text(
                                'Click Here',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingXLarge),

                      // Divider and Social Buttons (Commented Out by User)
                      // ... (Keeping comments or empty space if needed, effectively ignoring as they are commented out in source)
                      /* 
                       // Divider "Or"
                      Row(...),
                      SizedBox(...),
                      _buildSocialButton(...),
                      */

                      const Spacer(),

                      // Sign Up Link (Footer)
                      const SizedBox(height: AppConstants.paddingMedium),
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Navigate to Sign Up
                                },
                                child: Text(
                                  'Sign up',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.headlineSmall.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.surface,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    IconData? icon,
    required IconData iconData,
    Color? iconColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium), // Match text field radius usually or 30 for buttons
          ),
          // Design shows rounded pill shape similar to primary button or slightly less?
          // PrimaryButton uses 30. Let's stick to consistent 30 or match input?
          // Design image shows slightly less rounded than pill? Hard to tell. 
          // Text fields look like radiusMedium (12). Buttons look like 30.
          // Let's use 16 (radiusLarge) for these buttons as they look a bit more rectangular than the main Login button.
          // Actually main login button is 30. Let's make this 16.
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(iconData, color: iconColor ?? AppColors.textPrimary, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
