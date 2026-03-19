import 'package:flutter/material.dart';
import '../../services/firebase/auth_service.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/input_fields/mobile_number.dart';
import '../../widgets/buttons/send_otp_button.dart';
import 'verify_otp.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fill in the details to create your account',
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
                            if (_formKey.currentState!.validate()) {
                              final mobileNum = "+94${_mobileController.text}";
                              
                              // Save to SharedPreferences
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('mobileNumber', mobileNum);

                              await _authService.sendOTP(
                                context: context,
                                phoneNumber: mobileNum,
                                onCodeSent: (String verificationId, int? resendToken) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => VerifyOtpScreen(
                                          mobileNumber: mobileNum,
                                          verificationId: verificationId,
                                          role: "Customer",
                                        ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 30),
                        
                        // Already have an account text
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
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
                                          builder: (context) => const LoginScreen(role: 'Customer'),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Log In',
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
            ),
          ],
        ),
      ),
    );
  }
}
