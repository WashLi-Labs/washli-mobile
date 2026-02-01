import 'package:flutter/material.dart';
import '../../widgets/buttons/otp_verify_button.dart';
import '../data/otp_pinput.dart';
import 'user_account_details.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String mobileNumber;
  const VerifyOtpScreen({super.key, required this.mobileNumber});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
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
                text: 'We sent a verification code to your mobile number\n${widget.mobileNumber} ',
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
            
            Center(child: OtpPinput(controller: _otpController)),
            
            const SizedBox(height: 20),
            
            // Resend Code
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive any code? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserAccountDetailsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
