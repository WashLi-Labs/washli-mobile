import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  // Specify the custom database name 'washliauth'
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'washliauth',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Saves the user's account details to Firestore.
  /// Uses the Firebase Authentication UID as the document ID for the 'users' collection.
  Future<void> saveUserDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found. Cannot save details.");
      }

      // Merge data so it updates if they change their name later, rather than overriding everything completely.
      await _db.collection('users').doc(currentUser.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNumber': mobileNumber, // From SharedPreferences or auth
        'uid': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saving user details to Firestore: $e");
      rethrow; // Pass error to UI so user can be notified
    }
  }

  /// Updates the user's account details in Firestore.
  Future<void> updateUserDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String address,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found. Cannot update details.");
      }

      await _db.collection('users').doc(currentUser.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNumber': mobileNumber,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error updating user details in Firestore: $e");
      rethrow;
    }
  }

  /// Fetch user profile and save to preferences. Returns true if user data exists.
  Future<bool> syncUserProfileToPreferences() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      DocumentSnapshot doc = await _db
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (!doc.exists) return false;

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', data['firstName'] ?? '');
        await prefs.setString('lastName', data['lastName'] ?? '');
        await prefs.setString('email', data['email'] ?? '');
        await prefs.setString('mobileNumber', data['mobileNumber'] ?? '');
        if (data.containsKey('address')) {
          await prefs.setString('address', data['address'] ?? '');
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error syncing user profile: $e");
      return false;
    }
  }
}
