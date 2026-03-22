import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/role.dart';
import 'home/home_screen.dart';
import 'merchant/merchant_home/merchant_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final user = FirebaseAuth.instance.currentUser;

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if (user != null) {
          // Redirect based on role
          if (role == "Merchant") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MerchantHomeScreen()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          // Otherwise, go to Login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RoleScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20, // Adjust size as needed
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            children: [
              TextSpan(
                text: 'Wash',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'L',
                style: TextStyle(color: Color(0xFF007DFC)),
              ),
              TextSpan(
                text: 'i',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
