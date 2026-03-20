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
    final price = _parsePrice(priceStr);
    debugPrint('[CartNotifier] Adding/Updating: $title | PriceStr: $priceStr | Parsed: $price | Qty: $quantity');

    // Check if we are adding from a different shop
    if (state.shopName != null && state.shopName != shopName && state.items.isNotEmpty) {
      debugPrint('[CartNotifier] Different shop detected. Clearing old cart ($state.shopName).');
      state = CartState(shopName: shopName, items: []);
    }

    final existingItemIndex = state.items.indexWhere((item) => item.title == title);

    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(
        quantity: quantity,
        price: price, // Update price too in case it was 0.0 before or changed
      );
      state = state.copyWith(items: updatedItems, shopName: shopName);
      debugPrint('[CartNotifier] Updated existing item. New Total: ${state.totalAmount}');
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
      debugPrint('[CartNotifier] Added new item. New Total: ${state.totalAmount}');
    }
  }

  void updateQuantity(String title, int quantity) {
    if (quantity <= 0) {
      debugPrint('[CartNotifier] Removing item $title (qty <= 0)');
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
    debugPrint('[CartNotifier] Updated qty for $title. New Total: ${state.totalAmount}');
  }

  void removeItem(String title) {
    final updatedItems = state.items.where((item) => item.title != title).toList();
    state = state.copyWith(
      items: updatedItems,
      shopName: updatedItems.isEmpty ? null : state.shopName,
    );
    debugPrint('[CartNotifier] Removed $title. Remaining: ${state.items.length} items.');
  }

  void clearCart() {
    debugPrint('[CartNotifier] Clearing all items.');
    state = CartState();
  }

  double _parsePrice(String price) {
    if (price.isEmpty) return 0.0;
    
    // First, remove commas (common in pricing like 1,500.00)
    String cleaned = price.replaceAll(',', '');
    
    // Then, use a regex to extract the first numeric-looking thing (digits and a dot)
    final match = RegExp(r'(\d+\.?\d*)').firstMatch(cleaned);
    if (match != null) {
      final numericStr = match.group(0)!;
      final parsed = double.tryParse(numericStr) ?? 0.0;
      debugPrint('[CartNotifier] Parsing "$price" -> cleaned: "$numericStr" -> value: $parsed');
      return parsed;
    }
    
    debugPrint('[CartNotifier] FAILED to parse price: "$price"');
    return 0.0;
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
