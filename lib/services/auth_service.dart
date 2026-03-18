import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'washliauth',
  );
  final FirebaseFirestore _merchantDb = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'merchant-onboarding',
  );

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

  /// Checks if a user exists in Firestore based on their role and phone number.
  Future<bool> checkUserExists({
    required String phoneNumber,
    required String role,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      
      // Normalize phone numbers for comparison
      String localPhone =
          '0${phoneNumber.startsWith('+94') ? phoneNumber.substring(3) : phoneNumber}';
      String noLeadPhone =
          phoneNumber.startsWith('+94') ? phoneNumber.substring(3) : phoneNumber;

      final formats = [phoneNumber, localPhone, noLeadPhone];
      debugPrint("Checking existence for $role: $formats");

      // Define databases and queries to check
      List<FirebaseFirestore> databases;
      List<Map<String, String>> queries = [];

      if (role == "Merchant") {
        databases = [_merchantDb, _db, FirebaseFirestore.instance];
        queries.add({'collection': 'merchants', 'field': 'ownerPhone'});
        queries.add({'collection': 'merchant-onboarding', 'field': 'ownerPhone'});
      } else {
        databases = [_db, FirebaseFirestore.instance, _merchantDb];
        queries.add({'collection': 'users', 'field': 'mobileNumber'});
        queries.add({'collection': 'washliauth', 'field': 'phone'});
        queries.add({'collection': 'users', 'field': 'phone'});
      }

      // Create a list of all unique database-collection-field tasks
      List<Future<bool>> tasks = [];

      for (var db in databases) {
        for (var queryConfig in queries) {
          final col = queryConfig['collection']!;
          final field = queryConfig['field']!;
          
          tasks.add(() async {
            try {
              final query = await db
                  .collection(col)
                  .where(field, whereIn: formats)
                  .limit(1)
                  .get();
              
              if (query.docs.isNotEmpty) {
                debugPrint("Found user in $col ($field) in ${stopwatch.elapsedMilliseconds}ms");
                return true;
              }
            } catch (e) {
              // Ignore errors for individual database/collection mismatches
              debugPrint("Query failed for $col in a DB: $e");
            }
            return false;
          }());
        }
      }

      // Wait for all queries to complete
      final results = await Future.wait(tasks);
      final exists = results.any((element) => element == true);

      debugPrint("Check finished in ${stopwatch.elapsedMilliseconds}ms. Found: $exists");
      return exists;
    } catch (e) {
      debugPrint("Error checking user existence: $e");
      return false;
    }
  }
}
