import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/otp_verify_button.dart';
import '../../widgets/input_fields/otp_pinput.dart';
import 'user_account_details.dart';
import '../home/home_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String verificationId;
  const VerifyOtpScreen({
    super.key,
    required this.mobileNumber,
    required this.verificationId,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _checkOtp(String value) {
    setState(() {
      _isButtonEnabled = value.length == 6;
    });
  }

  void _onVerify() async {
    await _authService.verifyOTP(
      verificationId: widget.verificationId,
      smsCode: _otpController.text,
      onSuccess: () async {
        if (!mounted) return;

        // ⚠️ Wait a brief moment to ensure the background Cloud Function finishes
        await Future.delayed(const Duration(seconds: 2));

        // 🔄 Force refresh the token to grab the new custom claims via AuthService
        await _authService.refreshToken();

        // Check if user is fully registered
        bool isRegistered = await DatabaseService()
            .syncUserProfileToPreferences();

        if (mounted) {
          if (isRegistered) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserAccountDetailsScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }
      },
      onError: (String error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Invalid OTP: $error')));
        }
      },
    );
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
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
                        'Enter Code',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text:
                              'We sent a verification code to your mobile number\n${widget.mobileNumber} ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Color(0xFF0062FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: OtpPinput(
                          controller: _otpController,
                          onChanged: _checkOtp,
                          onCompleted: _checkOtp,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Resend Code
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive any code? ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("Resend code clicked");
                              },
                              child: const Text(
                                'Resend code',
                                style: TextStyle(
                                  color: Color(0xFF0062FF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      OtpVerifyButton(
                        onPressed: _isButtonEnabled ? _onVerify : null,
                      ),
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
