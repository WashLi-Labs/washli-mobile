import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
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
      home: const SplashScreen(),
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
