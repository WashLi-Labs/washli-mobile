import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../models/merchant/merchant_profile_model.dart';
import '../services/firebase/merchant_firebase_service.dart';
import '../get_location/location_service.dart';

/// Fetches all merchants (unordered) — used when position is unavailable.
final allMerchantsProvider =
    FutureProvider<List<MerchantProfileModel>>((ref) async {
  final list = await MerchantFirebaseService().fetchAllMerchants();
  debugPrint('[MerchantsListProvider] allMerchantsProvider: ${list.length} merchants.');
  return list;
});

/// Fetches the device's current GPS position safely.
/// Never throws — returns null if permission is denied or GPS is disabled.
final _userPositionProvider = FutureProvider<Position?>((ref) async {
  try {
    final pos = await LocationService().getPosition();
    debugPrint('[MerchantsListProvider] GPS position: ${pos?.latitude}, ${pos?.longitude}');
    return pos;
  } catch (e) {
    debugPrint('[MerchantsListProvider] GPS error (non-fatal): $e');
    return null;
  }
});

/// Fetches merchants sorted nearest-first using the device GPS position.
/// Falls back to showing ALL merchants (no distance) when GPS is unavailable.
/// Never propagates GPS errors — always returns a usable list.
final nearbyMerchantsProvider =
    FutureProvider<List<MerchantWithDistance>>((ref) async {
  final service = MerchantFirebaseService();

  // Safely get GPS — errors produce null, never crash the provider
  Position? position;
  try {
    position = await ref.read(_userPositionProvider.future);
  } catch (e) {
    debugPrint('[MerchantsListProvider] _userPositionProvider failed: $e');
    position = null;
  }

  if (position != null) {
    debugPrint('[MerchantsListProvider] Fetching nearby with lat=${position.latitude}, lng=${position.longitude}');
    final nearby = await service.fetchNearbyMerchants(
      userLat: position.latitude,
      userLng: position.longitude,
    );
    debugPrint('[MerchantsListProvider] nearbyMerchantsProvider: ${nearby.length} results.');
    return nearby;
  }

  // No GPS — return ALL merchants with null distance so the UI still shows content
  debugPrint('[MerchantsListProvider] No GPS — showing all merchants (unordered).');
  final all = await service.fetchAllMerchants();
  debugPrint('[MerchantsListProvider] Fallback: ${all.length} merchants total.');
  return all.map((m) => MerchantWithDistance(merchant: m)).toList();
});
