import 'package:flutter/material.dart';
import '../data/mobile_number.dart';
import '../../widgets/buttons/send_otp_button.dart';
import 'verify_otp.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _mobileController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VerifyOtpScreen(
                      mobileNumber: _mobileController.text.isEmpty ? "07178889954" : _mobileController.text,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
