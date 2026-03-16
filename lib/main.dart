import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'package:washli_mobile/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Disable App Verification for testing (Forces use of fictional phone numbers)
  // await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  // If you also want to force the Recaptcha flow for real numbers (if supported):
  await FirebaseAuth.instance.setSettings(forceRecaptchaFlow: true);

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
