import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart/cart_item_request.dart';
import '../models/cart/batch_cart_request.dart';
import '../models/cart/cart_response.dart';
import '../services/api/cart_api_service.dart';
import '../services/api/api_exception.dart';

final cartApiServiceProvider = Provider((ref) => CartApiService());

class AddToCartNotifier extends AsyncNotifier<void> {
  late final CartApiService _cartApiService;

  @override
  FutureOr<void> build() {
    _cartApiService = ref.read(cartApiServiceProvider);
  }

  Future<void> addItem(String merchantId, CartItemRequest req) async {
    state = const AsyncLoading();
    try {
      await _cartApiService.addItem(merchantId, req);
      state = const AsyncData(null);
    } catch (e, st) {
      if (e is ApiException) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(NetworkException(e.toString()), st);
      }
    }
  }

  Future<void> syncItems(String merchantId, BatchCartRequest req) async {
    state = const AsyncLoading();
    try {
      await _cartApiService.clearCart(merchantId);
      if (req.items.isNotEmpty) {
        await _cartApiService.addItems(merchantId, req);
      }
      state = const AsyncData(null);
    } catch (e, st) {
      if (e is ApiException) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(NetworkException(e.toString()), st);
      }
    }
  }

  Future<void> addItems(String merchantId, BatchCartRequest req) async {
    state = const AsyncLoading();
    try {
      await _cartApiService.addItems(merchantId, req);
      state = const AsyncData(null);
    } catch (e, st) {
      if (e is ApiException) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(NetworkException(e.toString()), st);
      }
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final addToCartProvider = AsyncNotifierProvider<AddToCartNotifier, void>(AddToCartNotifier.new);

class CartNotifier extends AsyncNotifier<CartResponse?> {
  late final CartApiService _cartApiService;

  @override
  FutureOr<CartResponse?> build() {
    _cartApiService = ref.read(cartApiServiceProvider);
    return null;
  }

  Future<void> loadCart(String merchantId) async {
    state = const AsyncLoading();
    try {
      final cart = await _cartApiService.getCart(merchantId);
      state = AsyncData(cart);
    } catch (e, st) {
      if (e is NotFoundException) {
        state = const AsyncData(null);
      } else if (e is ApiException) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(NetworkException(e.toString()), st);
      }
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, CartResponse?>(CartNotifier.new);
