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
          await _auth.signInWithCredential(credential);
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

      await _auth.signInWithCredential(credential);
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
}
