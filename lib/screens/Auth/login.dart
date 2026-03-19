import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/send_otp_button.dart';
import '../../widgets/input_fields/mobile_number.dart';
import 'verify_otp.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Log in to your account', 
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      const Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      MobileNumberInput(controller: _mobileController),
                      
                      const SizedBox(height: 30),
                      
                      SendOtpButton(
                        onPressed: () async {
                          final mobile = _mobileController.text;
                          if (mobile.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter mobile number'),
                              ),
                            );
                            return;
                          }

                          final formattedMobile = mobile.startsWith('+')
                              ? mobile
                              : '+94${mobile.startsWith('0') ? mobile.substring(1) : mobile}';

                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          // Check if user exists in Firestore
                          bool exists = await _authService.checkUserExists(
                            phoneNumber: formattedMobile,
                            role: widget.role,
                          );

                          if (!mounted) return;
                          Navigator.of(context).pop(); // Dismiss loading

                          if (!exists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User not registered. Please sign up'),
                              ),
                            );
                            return;
                          }

                          await _authService.sendOTP(
                            context: context,
                            phoneNumber: formattedMobile,
                            onCodeSent:
                                (String verificationId, int? resendToken) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VerifyOtpScreen(
                                    mobileNumber: formattedMobile,
                                    verificationId: verificationId,
                                    role: widget.role,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      
                      // Don't have an account text
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF007BFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
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
