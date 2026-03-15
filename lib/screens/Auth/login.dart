import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/send_otp_button.dart';
import '../../widgets/input_fields/mobile_number.dart';
import 'verify_otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
                          final mobile = _mobileController.text.isEmpty ? "07178889954" : _mobileController.text;
                          final formattedMobile = mobile.startsWith('+') ? mobile : '+94${mobile.startsWith('0') ? mobile.substring(1) : mobile}';
                          
                          await _authService.sendOTP(
                            context: context,
                            phoneNumber: formattedMobile,
                            onCodeSent: (String verificationId, int? resendToken) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VerifyOtpScreen(
                                    mobileNumber: formattedMobile,
                                    verificationId: verificationId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
