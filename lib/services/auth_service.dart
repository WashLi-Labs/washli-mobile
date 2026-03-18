import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sends an OTP to the provided phone number.
  Future<void> sendOTP({
    required BuildContext context,
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval of SMS code (usually works on Android)
        try {
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          String? token = await userCredential.user?.getIdToken();
          debugPrint("--- FIREBASE JWT TOKEN ---");
          debugPrint(token);
          debugPrint("---------------------------");
        } catch (e) {
          debugPrint("Auto-retrieval failed: $e");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        }
      },
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// Verifies the OTP and signs in the user.
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      String? token = await userCredential.user?.getIdToken();
      
      debugPrint("--- FIREBASE JWT TOKEN ---");
      debugPrint(token);
      debugPrint("---------------------------");

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'Unknown error occurred');
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Logs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Refreshes the current user's ID token to fetch newly added custom claims.
  Future<String?> refreshToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Force refresh (true) to pull latest claims from Firebase
        String? token = await user.getIdToken(true);
        debugPrint("--- REFRESHED FIREBASE JWT TOKEN (with claims) ---");
        debugPrint(token);
        debugPrint("--------------------------------------------------");
        return token;
      }
      return null;
    } catch (e) {
      debugPrint("Error refreshing token: $e");
      return null;
    }
  }
}
