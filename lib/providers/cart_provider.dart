import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String title;
  final double price;
  final int quantity;
  final String imagePath;
  final String description;

  CartItem({
    required this.title,
    required this.price,
    required this.quantity,
    required this.imagePath,
    required this.description,
  });

  CartItem copyWith({
    String? title,
    double? price,
    int? quantity,
    String? imagePath,
    String? description,
  }) {
    return CartItem(
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
    );
  }
}

class CartState {
  final String? shopName;
  final List<CartItem> items;

  CartState({
    this.shopName,
    this.items = const [],
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    String? shopName,
    List<CartItem>? items,
  }) {
    return CartState(
      shopName: shopName ?? this.shopName,
      items: items ?? this.items,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState();
  }

  void addItem({
    required String shopName,
    required String title,
    required String priceStr,
    required String imagePath,
    required String description,
    int quantity = 1,
  }) {
    // Check if we are adding from a different shop
    if (state.shopName != null && state.shopName != shopName && state.items.isNotEmpty) {
      state = CartState(shopName: shopName, items: []);
    }

    final price = _parsePrice(priceStr);
    final existingItemIndex = state.items.indexWhere((item) => item.title == title);

    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(
        quantity: quantity,
      );
      state = state.copyWith(items: updatedItems, shopName: shopName);
    } else {
      state = state.copyWith(
        shopName: shopName,
        items: [
          ...state.items,
          CartItem(
            title: title,
            price: price,
            quantity: quantity,
            imagePath: imagePath,
            description: description,
          ),
        ],
      );
    }
  }

  void updateQuantity(String title, int quantity) {
    if (quantity <= 0) {
      removeItem(title);
      return;
    }
    final updatedItems = state.items.map((item) {
      if (item.title == title) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    state = state.copyWith(items: updatedItems);
  }

  void removeItem(String title) {
    final updatedItems = state.items.where((item) => item.title != title).toList();
    state = state.copyWith(
      items: updatedItems,
      shopName: updatedItems.isEmpty ? null : state.shopName,
    );
  }

  void clearCart() {
    state = CartState();
  }

  double _parsePrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
