import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/merchant_profile_model.dart';
import '../services/firebase/merchant_firebase_service.dart';

// ──────────────────────────────────────────────────────────────
// State
// ──────────────────────────────────────────────────────────────

/// Immutable state held by [MerchantNotifier].
class MerchantState {
  final MerchantProfileModel? merchant;
  final bool isLoading;
  final String? errorMessage;

  const MerchantState({
    this.merchant,
    this.isLoading = false,
    this.errorMessage,
  });

  MerchantState copyWith({
    MerchantProfileModel? merchant,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearMerchant = false,
  }) {
    return MerchantState(
      merchant: clearMerchant ? null : (merchant ?? this.merchant),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────

/// Manages the logged-in merchant's own profile state.
/// Follows the project's [Notifier] pattern (Riverpod 2+).
class MerchantNotifier extends Notifier<MerchantState> {
  StreamSubscription<MerchantProfileModel?>? _merchantSubscription;

  MerchantFirebaseService get _service =>
      ref.read(merchantServiceProvider);

  @override
  MerchantState build() {
    ref.onDispose(() => stopWatching());
    return const MerchantState();
  }

  // ──────────────────────────────────────
  // Convenience getters
  // ──────────────────────────────────────

  MerchantProfileModel? get merchant => state.merchant;
  bool get isLoading => state.isLoading;
  String? get errorMessage => state.errorMessage;
  bool get isShopOpen => state.merchant?.isActive ?? false;
  String get displayName => state.merchant?.outletName ?? 'Merchant';
  String get profileImageUrl => state.merchant?.outletLogo ?? '';

  // ──────────────────────────────────────
  // Load (one-shot fetch)
  // ──────────────────────────────────────

  Future<void> loadMerchantProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await _service.getMerchantProfile();
      state = state.copyWith(merchant: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load profile: $e',
      );
    }
  }

  // ──────────────────────────────────────
  // Real-time stream
  // ──────────────────────────────────────

  void startWatching() {
    _merchantSubscription?.cancel();
    _merchantSubscription = _service.watchMerchantProfile().listen(
      (profile) {
        state = state.copyWith(merchant: profile, clearError: true);
      },
      onError: (Object e) {
        state = state.copyWith(errorMessage: 'Profile stream error: $e');
      },
    );
  }

  void stopWatching() {
    _merchantSubscription?.cancel();
    _merchantSubscription = null;
  }

  // ──────────────────────────────────────
  // Write operations
  // ──────────────────────────────────────

  Future<void> updateProfile(MerchantProfileModel updated) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.updateMerchantProfile(updated);
      state = state.copyWith(merchant: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile: $e',
      );
    }
  }

  Future<void> uploadAndSetProfileImage(File imageFile) async {
    try {
      final String? url = await _service.uploadProfileImage(imageFile);
      if (url != null && state.merchant != null) {
        state = state.copyWith(
          merchant: state.merchant!.copyWith(outletLogo: url),
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to upload image: $e');
    }
  }

  /// Optimistic toggle — updates UI instantly then syncs to Firestore.
  /// Reverts if the Firestore write fails.
  Future<void> toggleShopStatus() async {
    if (state.merchant == null) return;

    final MerchantProfileModel previous = state.merchant!;
    final bool newStatus = !previous.isActive;

    state = state.copyWith(merchant: previous.copyWith(isActive: newStatus));

    try {
      await _service.toggleActiveStatus(newStatus);
    } catch (e) {
      state = state.copyWith(
        merchant: previous,
        errorMessage: 'Failed to toggle shop status: $e',
      );
    }
  }

  /// Clears any displayed error message.
  void clearError() => state = state.copyWith(clearError: true);
}

// ──────────────────────────────────────────────────────────────
// Providers
// ──────────────────────────────────────────────────────────────

/// Provides a scoped [MerchantFirebaseService] instance.
final merchantServiceProvider = Provider<MerchantFirebaseService>(
  (ref) => MerchantFirebaseService(),
);

/// Provides the merchant profile state notifier.
final merchantProvider =
    NotifierProvider<MerchantNotifier, MerchantState>(
  MerchantNotifier.new,
);
