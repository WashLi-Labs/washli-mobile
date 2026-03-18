import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  // Specify the custom database names
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'washliauth',
  );
  final FirebaseFirestore _merchantDb = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'merchant-onboarding',
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
    String? role,
    String? profileImageUrl,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found. Cannot update details.");
      }

      final prefs = await SharedPreferences.getInstance();
      String currentRole = role ?? prefs.getString('role') ?? 'Customer';

      Map<String, dynamic> updateData = {};

      if (currentRole == "Merchant") {
        updateData = {
          'outletName': firstName, // Mapping firstName to outletName
          'ownerEmail': email,
          'ownerPhone': mobileNumber,
          'outletAddress': address,
          'updatedAt': FieldValue.serverTimestamp(),
        };
      } else {
        updateData = {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'mobileNumber': mobileNumber,
          'address': address,
          'updatedAt': FieldValue.serverTimestamp(),
        };
      }

      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      if (currentRole == "Merchant") {
        // List of database instances to search
        List<FirebaseFirestore> databases = [
          _merchantDb, // 'merchant-onboarding'
          _db, // 'washliauth'
          FirebaseFirestore.instance, // default
        ];
        List<String> collections = ['merchants', 'merchant-onboarding'];
        
        bool updated = false;
        List<Future<bool>> updateTasks = [];

        for (var db in databases) {
          for (var col in collections) {
            // Task: Try updating by UID first
            updateTasks.add(() async {
              try {
                DocumentSnapshot doc = await db.collection(col).doc(currentUser.uid).get();
                if (doc.exists) {
                  await db.collection(col).doc(currentUser.uid).set(updateData, SetOptions(merge: true));
                  return true;
                }
              } catch (_) {}
              return false;
            }());
          }
        }

        // Wait for UID updates
        List<bool> uidResults = await Future.wait(updateTasks);
        updated = uidResults.any((r) => r);

        // If not found by UID, search by phone number
        if (!updated && currentUser.phoneNumber != null) {
          String phone = currentUser.phoneNumber!;
          String localPhone = '0${phone.startsWith('+94') ? phone.substring(3) : phone}';
          String noLeadPhone = phone.startsWith('+94') ? phone.substring(3) : phone;
          List<String> phoneFormats = [phone, localPhone, noLeadPhone];

          List<Future<bool>> phoneTasks = [];
          for (var db in databases) {
            for (var col in collections) {
              phoneTasks.add(() async {
                try {
                  final query = await db
                      .collection(col)
                      .where('ownerPhone', whereIn: phoneFormats)
                      .limit(1)
                      .get();
                  if (query.docs.isNotEmpty) {
                    await query.docs.first.reference.set(updateData, SetOptions(merge: true));
                    return true;
                  }
                } catch (_) {}
                return false;
              }());
            }
          }
          List<bool> phoneResults = await Future.wait(phoneTasks);
          updated = phoneResults.any((r) => r);
        }

        // Final fallback if document still not found anywhere - create in default merchantDb
        if (!updated) {
          await _merchantDb.collection('merchant-onboarding').doc(currentUser.uid).set(updateData, SetOptions(merge: true));
        }
      } else {
        await _db.collection('users').doc(currentUser.uid).set(updateData, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error updating user details in Firestore: $e");
      rethrow;
    }
  }

  /// Uploads a profile image to Firebase Storage and returns the download URL
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser.uid}.jpg');

      // Upload the file
      final uploadTask = await storageRef.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      return null;
    }
  }

  Future<bool> syncUserProfileToPreferences({String? role}) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        debugPrint("Sync Error: currentUser is null");
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      String currentRole = role ?? prefs.getString('role') ?? 'Customer';

      DocumentSnapshot? doc;
      if (currentRole == "Merchant") {
        // List of database instances to search
        List<FirebaseFirestore> databases = [
          _merchantDb, // 'merchant-onboarding'
          _db, // 'washliauth'
          FirebaseFirestore.instance, // default
        ];

        // For merchants, check 'merchants' and 'merchant-onboarding' collections across all DBs
        List<String> collections = ['merchants', 'merchant-onboarding'];
        List<String> phoneFormats = [];
        if (currentUser.phoneNumber != null) {
          String phone = currentUser.phoneNumber!;
          String localPhone = '0${phone.startsWith('+94') ? phone.substring(3) : phone}';
          String noLeadPhone = phone.startsWith('+94') ? phone.substring(3) : phone;
          phoneFormats = [phone, localPhone, noLeadPhone];
        }

        List<Future<DocumentSnapshot?>> tasks = [];

        for (var db in databases) {
          for (String col in collections) {
            // Task 1: Check by UID
            tasks.add(() async {
              try {
                var d = await db.collection(col).doc(currentUser.uid).get();
                return d.exists ? d : null;
              } catch (_) {
                return null;
              }
            }());

            // Task 2: Check by Phone (if available)
            if (phoneFormats.isNotEmpty) {
              tasks.add(() async {
                try {
                  final query = await db
                      .collection(col)
                      .where('ownerPhone', whereIn: phoneFormats)
                      .limit(1)
                      .get();
                  return query.docs.isNotEmpty ? query.docs.first : null;
                } catch (_) {
                  return null;
                }
              }());
            }
          }
        }

        final results = await Future.wait(tasks);
        doc = results.firstWhere((d) => d != null, orElse: () => null);
      } else {
        debugPrint("Sync Progress: Checking 'users' collection for UID: ${currentUser.uid}");
        doc = await _db.collection('users').doc(currentUser.uid).get();
      }

      if (doc == null || !doc.exists) {
        debugPrint("Sync Error: No document found for $currentRole after all checks.");
        return false;
      }

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        debugPrint("Sync Progress: Document data found: $data");
        if (currentRole == "Merchant") {
          // Fields for merchant (based on typical schema and user instructions)
          await prefs.setString('firstName',
              data['outletName'] ?? data['shopName'] ?? data['merchantName'] ?? 'Merchant');
          await prefs.setString('lastName', ''); // Merchants might not have a last name
          await prefs.setString('email', data['ownerEmail'] ?? data['email'] ?? '');
          await prefs.setString('mobileNumber', data['ownerPhone'] ?? data['phone'] ?? (currentUser.phoneNumber ?? ''));
          await prefs.setString('address',
              data['outletAddress'] ?? data['shopAddress'] ?? data['address'] ?? '');
          debugPrint("Sync Progress: Merchant fields saved to SharedPreferences");
        } else {
          // Fields for customer
          await prefs.setString('firstName', data['firstName'] ?? '');
          await prefs.setString('lastName', data['lastName'] ?? '');
          await prefs.setString('email', data['email'] ?? '');
          await prefs.setString('mobileNumber', data['mobileNumber'] ?? (currentUser.phoneNumber ?? ''));
          if (data.containsKey('address')) {
            await prefs.setString('address', data['address'] ?? '');
          }
          debugPrint("Sync Progress: Customer fields saved to SharedPreferences");
        }

        if (data.containsKey('profileImageUrl')) {
          await prefs.setString('profileImageUrl', data['profileImageUrl'] ?? '');
          debugPrint("Sync Progress: profileImageUrl saved: ${data['profileImageUrl']}");
        }
        return true;
      }
      debugPrint("Sync Error: data is null even if document exists");
      return false;
    } catch (e) {
      debugPrint("Sync Error: Exception during syncing: $e");
      return false;
    }
  }
}
