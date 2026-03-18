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
      // Normalize phone numbers for comparison
      // Assuming phoneNumber is already in +947XXXXXXXX format (from LoginScreen)
      String localPhone =
          '0${phoneNumber.startsWith('+94') ? phoneNumber.substring(3) : phoneNumber}';
      String noLeadPhone =
          phoneNumber.startsWith('+94') ? phoneNumber.substring(3) : phoneNumber;

      debugPrint("Checking existence for $role: $phoneNumber or $localPhone or $noLeadPhone");

      // List of query configurations to try
      List<Map<String, String>> queries = [];

      if (role == "Merchant") {
        queries.add({'collection': 'merchants', 'field': 'ownerPhone'});
        queries.add({'collection': 'merchant-onboarding', 'field': 'ownerPhone'});
      } else {
        // Fallbacks for existing standard users (highest priority first)
        queries.add({'collection': 'users', 'field': 'mobileNumber'});
        // Based on user instructions
        queries.add({'collection': 'washliauth', 'field': 'phone'});
        queries.add({'collection': 'users', 'field': 'phone'});
      }

      // Order databases based on role
      List<FirebaseFirestore> dbInstances;
      if (role == "Merchant") {
        dbInstances = [
          _merchantDb, // 'merchant-onboarding'
          _db, // 'washliauth'
          FirebaseFirestore.instance, // (default)
        ];
      } else {
        dbInstances = [
          _db, // 'washliauth'
          FirebaseFirestore.instance, // (default)
          _merchantDb, // 'merchant-onboarding'
        ];
      }

      for (int i = 0; i < dbInstances.length; i++) {
        var db = dbInstances[i];
        String dbLabel = i == 0 ? (role == "Merchant" ? "MerchantDB" : "WashLiAuthDB") : "Default/OtherDB";
        debugPrint("Searching in database index $i ($dbLabel)");

        for (var queryConfig in queries) {
          String col = queryConfig['collection']!;
          String field = queryConfig['field']!;

          try {
            debugPrint("Querying collection '$col' field '$field'...");
            
            // Try all formats in a single batch (or sequential)
            // 1. International format
            QuerySnapshot intlQuery = await db
                .collection(col)
                .where(field, isEqualTo: phoneNumber)
                .limit(1)
                .get();
            if (intlQuery.docs.isNotEmpty) {
              debugPrint("Found user in database index $i -> $col ($field: $phoneNumber)");
              return true;
            }

            // 2. Local format
            QuerySnapshot localQuery = await db
                .collection(col)
                .where(field, isEqualTo: localPhone)
                .limit(1)
                .get();
            if (localQuery.docs.isNotEmpty) {
              debugPrint("Found user in database index $i -> $col ($field: $localPhone)");
              return true;
            }

            // 3. No leading format
            QuerySnapshot noLeadQuery = await db
                .collection(col)
                .where(field, isEqualTo: noLeadPhone)
                .limit(1)
                .get();
            if (noLeadQuery.docs.isNotEmpty) {
              debugPrint("Found user in database index $i -> $col ($field: $noLeadPhone)");
              return true;
            }
          } catch (e) {
            // Some databases might not have the collection, ignore and continue
            debugPrint("Query failed for $col in DB index $i: $e");
          }
        }
      }

      debugPrint("No user found for $role with $phoneNumber after all checks");
      return false;
    } catch (e) {
      debugPrint("Error checking user existence: $e");
      return false;
    }
  }
}
