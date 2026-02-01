import 'package:flutter/material.dart';
import '../../widgets/buttons/swipe_button.dart';
import 'signup.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100), // Adjusted top spacing
              // Header Text
              Text(
                'Elevate Your\nLaundry Routine',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 40, // Increased size slightly to match reference
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Effortless Care And Sparking Results!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Swipe Button
              SwipeButton(
                onSwipe: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}


