import 'package:flutter/material.dart';
import '../../widgets/buttons/merchant_btn.dart';
import '../../widgets/buttons/customer_btn.dart';
import 'merchant_signup.dart';
import 'signup.dart';
import 'login.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // The top portion uses Expanded so it takes all available remaining space minus the bottom container
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset(
                    'assets/images/image 1514.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // The bottom portion size adapts perfectly to its content without needing to scroll
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF007BFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                32.0,
                40.0,
                32.0,
                50.0,
              ), // slightly more padding on top/bottom
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ready to get\nstarted?',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Join as a Merchant to grow your business,\nor as a Customer to enjoy our services.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        MerchantBtn(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MerchantSignupScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomerBtn(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignupScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
