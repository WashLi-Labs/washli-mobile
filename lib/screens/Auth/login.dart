import 'package:flutter/material.dart';
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
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D3A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details to create your account', // Copied text from image, though "create your account" is weird for login, but sticking to image reference "Fill in the details to create your account" is visible in step 303 image for Login screen? Wait.
              // Looking at image 1769952367270.png in Step 303.
              // Header: "Login"
              // Subheader: "Fill in the details to create your account" (This seems like a copy paste error in design, but I will replicate it or maybe correct it to "Fill in the details to log in". User asked to "create this login screen", implying exact copy. I'll stick to the text in the image.)
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
