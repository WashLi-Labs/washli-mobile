import 'package:flutter/material.dart';
import 'screens/Auth/onboarding.dart';
import 'package:washli_mobile/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Washli',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      home: const OnboardingScreen(),
      theme: AppTheme.lightTheme,
=======
      home: const SplashScreen(),
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
>>>>>>> aed5c09eb358f8dae6618dc9a30fbfffb1c57a53
    );
  }
}
