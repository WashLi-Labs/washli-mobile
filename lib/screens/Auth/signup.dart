import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/input_fields/mobile_number.dart';
import '../../widgets/buttons/send_otp_button.dart';
import 'verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: mobileNum,
                                verificationCompleted: (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Verification failed: ${e.message}')),
                                  );
                                },
                                codeSent: (String verificationId, int? resendToken) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VerifyOtpScreen(
                                        mobileNumber: mobileNum,
                                        verificationId: verificationId,
                                      ),
                                    ),
                                  );
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                              );
                            }
                          },
                        ),
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
