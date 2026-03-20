import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../models/merchant_profile_model.dart';

/// Handles all Firestore and Storage operations for the logged-in merchant's
/// own profile. Independent of [DatabaseService] — uses its own db connection.
class MerchantFirebaseService {
  // ──────────────────────────────────────────────────────────
  // Collection name constants
  // ──────────────────────────────────────────────────────────
  static const String merchantsCol = 'merchants';
  static const String merchantOnboardingCol = 'merchant-onboarding';

  // ──────────────────────────────────────────────────────────
  // Firebase instances
  // ──────────────────────────────────────────────────────────
  final FirebaseFirestore _merchantDb = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'merchant-onboarding',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ──────────────────────────────────────────────────────────
  // Private helpers
  // ──────────────────────────────────────────────────────────

  /// Returns [phone, 0XXXXXXXXX, XXXXXXXXX] for the given phone string.
  List<String> _getPhoneFormats(String phone) {
    final String local =
        '0${phone.startsWith('+94') ? phone.substring(3) : phone}';
    final String noLead =
        phone.startsWith('+94') ? phone.substring(3) : phone;
    return [phone, local, noLead];
  }

  /// Searches 'merchants' and 'merchant-onboarding' by UID (doc lookup) and
  /// by ownerPhone (query) in parallel. Returns the first matching document.
  Future<DocumentSnapshot?> _findMerchantDoc() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final String uid = user.uid;
    final List<String> phoneFormats = user.phoneNumber != null
        ? _getPhoneFormats(user.phoneNumber!)
        : <String>[];

    // Build 4 parallel futures — UID lookups + phone queries across 2 collections
    final List<Future<DocumentSnapshot?>> futures = [
      // 1. UID in 'merchants'
      _merchantDb
          .collection(merchantsCol)
          .doc(uid)
          .get()
          .then((d) => d.exists ? d : null)
          .catchError((_) => null),

      // 2. UID in 'merchant-onboarding'
      _merchantDb
          .collection(merchantOnboardingCol)
          .doc(uid)
          .get()
          .then((d) => d.exists ? d : null)
          .catchError((_) => null),
    ];

    // 3 & 4. Phone queries (only if phone is available)
    if (phoneFormats.isNotEmpty) {
      futures.add(
        _merchantDb
            .collection(merchantsCol)
            .where('ownerPhone', whereIn: phoneFormats)
            .limit(1)
            .get()
            .then((q) => q.docs.isNotEmpty ? q.docs.first : null)
            .catchError((_) => null),
      );
      futures.add(
        _merchantDb
            .collection(merchantOnboardingCol)
            .where('ownerPhone', whereIn: phoneFormats)
            .limit(1)
            .get()
            .then((q) => q.docs.isNotEmpty ? q.docs.first : null)
            .catchError((_) => null),
      );
    }

    final List<DocumentSnapshot?> results = await Future.wait(futures);
    return results.firstWhere((d) => d != null, orElse: () => null);
  }

  // ──────────────────────────────────────────────────────────
  // Public API — current merchant's profile
  // ──────────────────────────────────────────────────────────

  /// Fetches the current merchant's profile once. Returns null if not found.
  Future<MerchantProfileModel?> getMerchantProfile() async {
    try {
      final DocumentSnapshot? doc = await _findMerchantDoc();
      if (doc == null) {
        debugPrint('[MerchantService] No merchant document found for current user.');
        return null;
      }
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;
      return MerchantProfileModel.fromMap({...data, 'uid': doc.id});
    } catch (e) {
      debugPrint('[MerchantService] getMerchantProfile error: $e');
      return null;
    }
  }

  /// Streams the merchant document from the 'merchants' collection by UID.
  Stream<MerchantProfileModel?> watchMerchantProfile() {
    final User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _merchantDb
        .collection(merchantsCol)
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          final data = snapshot.data();
          if (data == null) return null;
          return MerchantProfileModel.fromMap({...data, 'uid': snapshot.id});
        })
        .handleError((Object e) {
          debugPrint('[MerchantService] watchMerchantProfile stream error: $e');
        });
  }

  /// Updates (or creates) the merchant document with [SetOptions.merge].
  Future<void> updateMerchantProfile(MerchantProfileModel merchant) async {
    try {
      final DocumentSnapshot? existingDoc = await _findMerchantDoc();
      if (existingDoc != null) {
        await existingDoc.reference.set(merchant.toMap(), SetOptions(merge: true));
        debugPrint('[MerchantService] Merchant profile updated at ${existingDoc.reference.path}');
      } else {
        final String uid = _auth.currentUser!.uid;
        await _merchantDb
            .collection(merchantsCol)
            .doc(uid)
            .set(merchant.toMap(), SetOptions(merge: true));
        debugPrint('[MerchantService] Merchant profile created at $merchantsCol/$uid');
      }
    } catch (e) {
      debugPrint('[MerchantService] updateMerchantProfile error: $e');
      rethrow;
    }
  }

  /// Uploads [imageFile] to Firebase Storage and returns the download URL.
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final String uid = _auth.currentUser!.uid;
      final Reference ref = _storage.ref().child('merchant_profiles/$uid.jpg');
      await ref.putFile(imageFile);
      final String downloadUrl = await ref.getDownloadURL();
      debugPrint('[MerchantService] outletLogo uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('[MerchantService] uploadProfileImage error: $e');
      return null;
    }
  }

  /// Toggles the merchant's active/open status in Firestore.
  Future<void> toggleActiveStatus(bool isActive) async {
    try {
      final DocumentSnapshot? doc = await _findMerchantDoc();
      if (doc == null) {
        debugPrint('[MerchantService] toggleActiveStatus: no document found.');
        return;
      }
      await doc.reference.set(
        {'isActive': isActive, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
      debugPrint('[MerchantService] isActive set to $isActive');
    } catch (e) {
      debugPrint('[MerchantService] toggleActiveStatus error: $e');
    }
  }

  // ──────────────────────────────────────────────────────────
  // Public API — all merchants (customer-facing)
  // ──────────────────────────────────────────────────────────

  /// Fetches all merchants from the publicly-readable 'merchants' collection.
  /// The 'merchant-onboarding' collection has stricter Firestore rules and is
  /// not queried here (only used for the logged-in merchant's own profile).
  /// Each document is parsed defensively — a bad doc is skipped, not fatal.
  Future<List<MerchantProfileModel>> fetchAllMerchants() async {
    try {
      final QuerySnapshot snap =
          await _merchantDb.collection(merchantsCol).get();

      final List<MerchantProfileModel> result = [];
      for (final doc in snap.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          result.add(MerchantProfileModel.fromMap({...data, 'uid': doc.id}));
        } catch (e) {
          // Skip malformed documents rather than crashing the whole list
          debugPrint('[MerchantService] fetchAllMerchants: skipping doc ${doc.id} — $e');
        }
      }

      debugPrint('[MerchantService] fetchAllMerchants: ${result.length} merchants loaded.');
      return result;
    } catch (e) {
      debugPrint('[MerchantService] fetchAllMerchants error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────
  // Nearby merchants — distance sorted
  // ──────────────────────────────────────────────────────────

  /// Haversine formula — returns distance in kilometres.
  double _haversineKm(
      double lat1, double lng1, double lat2, double lng2) {
    const double r = 6371;
    final double dLat = _toRad(lat2 - lat1);
    final double dLng = _toRad(lng2 - lng1);
    final double a = math.pow(math.sin(dLat / 2), 2) +
        math.pow(math.sin(dLng / 2), 2) *
            math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2));
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _toRad(double deg) => deg * math.pi / 180;

  /// Fetches all merchants and sorts by distance from [userLat]/[userLng].
  /// Only merchants within 20 km are included; those without a `location`
  /// field in Firestore are appended last regardless of radius.
  Future<List<MerchantWithDistance>> fetchNearbyMerchants({
    required double userLat,
    required double userLng,
  }) async {
    const double radiusKm = 10.0;
    final List<MerchantProfileModel> all = await fetchAllMerchants();

    final List<MerchantWithDistance> withDist = [];
    final List<MerchantWithDistance> noLocation = [];

    for (final m in all) {
      if (m.location != null &&
          (m.location!.lat != 0.0 || m.location!.lng != 0.0)) {
        final double dist =
            _haversineKm(userLat, userLng, m.location!.lat, m.location!.lng);
        if (dist <= radiusKm) {
          withDist.add(MerchantWithDistance(merchant: m, distanceKm: dist));
        }
      } else {
        // No GPS coords — include but sorted to the end
        noLocation.add(MerchantWithDistance(merchant: m));
      }
    }

    // Sort merchants with known distance nearest-first
    withDist.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));

    final result = [...withDist, ...noLocation];
    debugPrint('[MerchantService] fetchNearbyMerchants: '
        '${withDist.length} within ${radiusKm}km, '
        '${noLocation.length} without location.');
    return result;
  }
}

// ──────────────────────────────────────────────────────────────
// Wrapper — merchant + computed distance
// ──────────────────────────────────────────────────────────────

/// Pairs a [MerchantProfileModel] with its computed distance from the user.
class MerchantWithDistance {
  final MerchantProfileModel merchant;

  /// `null` when the merchant has no `location` data in Firestore.
  final double? distanceKm;

  const MerchantWithDistance({required this.merchant, this.distanceKm});

  /// Human-readable label, e.g. "1.2 km away" or "850 m away".
  String get distanceLabel {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()} m away';
    return '${distanceKm!.toStringAsFixed(1)} km away';
  }
}
