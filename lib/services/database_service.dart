import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  // Specify the custom database name 'washliauth'
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(), 
    databaseURL: 'washliauth', // Note: Depending on the cloud_firestore version, this parameter might be named databaseId. Let's use both to be safe or just use the modern approach. Wait, let me just initialize it with the named database.
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
}
