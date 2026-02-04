import 'package:flutter/material.dart';
import 'screens/Auth/onboarding.dart';
import 'package:washli_mobile/theme/app_theme.dart';

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
      home: const OnboardingScreen(),
      theme: AppTheme.lightTheme,
    );
  }
}
