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

  Future<void> clearCart(String merchantId) async {
    try {
      await _cartApiService.clearCart(merchantId);
      state = const AsyncData(null);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(String cartItemId) async {
    final currentCart = state.value;
    if (currentCart == null) return;
    
    try {
      await _cartApiService.deleteItem(cartItemId);
      await loadCart(currentCart.merchantId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    final currentCart = state.value;
    if (currentCart == null) return;
    
    try {
      final updatedItem = await _cartApiService.updateItemQuantity(cartItemId, quantity);
      
      final updatedItems = currentCart.items.map((item) {
        return item.id == cartItemId ? updatedItem : item;
      }).toList();
      
      final newTotal = updatedItems.fold<double>(0, (sum, item) => sum + item.subtotal);
      
      state = AsyncData(CartResponse(
        id: currentCart.id,
        merchantId: currentCart.merchantId,
        merchantName: currentCart.merchantName,
        status: currentCart.status,
        itemsTotal: newTotal,
        items: updatedItems,
      ));
    } catch (e) {
      // Intentionally swallow UI exceptions here to allow optimistic fallback 
      // or optionally rethrow to handle in UI. For now, leave state as is on failure.
      rethrow;
    }
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, CartResponse?>(CartNotifier.new);
