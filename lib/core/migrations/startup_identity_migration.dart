import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../models/merchant/merchant_profile_model.dart';

/// A one-time startup utility designed for Development and Staging.
/// It ensures that test accounts have their merchant profile document ID
/// perfectly aligned with their Firebase Auth UID.
class StartupIdentityMigration {
  static const String _merchantsCol = 'merchants';

  /// Add your test numbers here in all formats you use.
  static const List<String> _testNumbers = [
    '0717262554',
    '+94717262554',
    '717262554',
  ];

  /// Runs the identity check and migration logic.
  /// Typically called in main() after Firebase initialization.
  static Future<void> run() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('[Migration] No user logged in. Skipping identity check.');
      return;
    }

    final String? phone = user.phoneNumber;
    final String uid = user.uid;

    // Condition 1: Must be a test number to proceed (Safety Guard)
    bool isTestNumber = false;
    if (phone != null) {
      isTestNumber = _testNumbers.any((num) => phone.contains(num));
    }

    // Fallback: If user is logged in with a test number but phoneNumber is null in Auth profile
    // (though usually, phone auth populates this)
    if (!isTestNumber) {
      debugPrint(
        '[Migration] Current user ($phone) is not in the test list. Skipping migration.',
      );
      return;
    }

    debugPrint(
      '[Migration] Test user detected: $phone (UID: $uid). Waiting for Auth sync...',
    );

    // CRITICAL: Ensure Firebase Auth has fully propagated the token to the Firestore client.
    // Reading currentUser from disk is fast, but Firestore needs the async token.
    try {
      await FirebaseAuth.instance.idTokenChanges().first;
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (_) {}

    debugPrint('[Migration] Checking identity sync...');

    try {
      final FirebaseFirestore db = FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: 'merchant-onboarding',
      );

      // 1. Check if the UID document already exists
      final uidDoc = await db.collection(_merchantsCol).doc(uid).get();
      if (uidDoc.exists) {
        debugPrint(
          '[Migration] Identity already synced for UID: $uid. No action needed.',
        );
        return;
      }

      // 2. Search for the merchant profile by phone number (The Legacy Document)
      // We look for any doc where 'ownerPhone' matches the test number formats.
      final querySnap = await db
          .collection(_merchantsCol)
          .where('ownerPhone', whereIn: _testNumbers)
          .limit(1)
          .get();

      if (querySnap.docs.isEmpty) {
        debugPrint(
          '[Migration] No legacy profile found for phone $phone. Skipping move.',
        );
        return;
      }

      final legacyDoc = querySnap.docs.first;
      final String oldId = legacyDoc.id;

      // Safety check: if oldId happens to be the uid (unlikely if uidDoc didn't exist)
      if (oldId == uid) {
        debugPrint('[Migration] Legacy ID is already the UID. Logic complete.');
        return;
      }

      debugPrint(
        '[Migration] Legacy Profile Found (ID: $oldId). Migrating to new UID: $uid...',
      );

      // 3. SAFE COPIER (Create UID Document from Legacy Data)
      // We only do the 'Set' because Security Rules usually prevent
      // a client from deleting a document that doesn't match their UID.
      final DocumentReference newRef = db.collection(_merchantsCol).doc(uid);

      // Parse the legacy data through the model to ensure all required fields
      // exist and match the schema required by Firestore Security Rules.
      final Map<String, dynamic> rawData =
          legacyDoc.data() as Map<String, dynamic>;
      final profile = MerchantProfileModel.fromMap({...rawData, 'uid': uid});

      try {
        await newRef.set(profile.toMap(), SetOptions(merge: true));
        debugPrint(
          '[Migration] SUCCESS! Merchant profile copied from $oldId to $uid. You can now manually delete the old record in the console.',
        );
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          debugPrint(
            '========================================================================',
          );
          debugPrint(
            '[Migration] FIREBASE SECURITY RULES ARE BLOCKING THE MIGRATION!',
          );
          debugPrint(
            'Your Firestore rules forbid the mobile app from creating this document.',
          );
          debugPrint('To fix this, you have two options:');
          debugPrint(
            'OPTION 1: Temporarily change Firestore Rules to: allow write: if true; then restart the app, then change it back.',
          );
          debugPrint(
            'OPTION 2: Do it manually. Here is your exact 20-column data. Go to Firebase Console, create document $uid, and paste this:',
          );
          debugPrint(jsonEncode(profile.toMap()));
          debugPrint(
            '========================================================================',
          );
        } else {
          debugPrint('[Migration] ERROR during identity migration: $e');
        }
      }
    } catch (e) {
      debugPrint('[Migration] Unexpected outer error: $e');
    }
  }
}
