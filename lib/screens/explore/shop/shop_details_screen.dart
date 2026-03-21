import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washli_mobile/providers/cart_provider.dart';
import 'package:washli_mobile/screens/cart/cart_screen.dart';
import 'package:washli_mobile/screens/cart/widgets/clear_cart_popup.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/input_fields/custom_search_bar.dart';
import 'widgets/service_card.dart';
import 'widgets/shop_header.dart';

import '../../../models/cart/cart_item_request.dart';
import '../../../models/cart/batch_cart_request.dart';
import '../../../services/api/api_exception.dart';
import '../../../data/temp_catalog.dart';

class ShopDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> laundry;

  const ShopDetailsScreen({super.key, required this.laundry});

  @override
  ConsumerState<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends ConsumerState<ShopDetailsScreen> {
  final Map<String, int> selectedQuantities = {};
  bool _initialized = false;

  void _handleBack(BuildContext context) {
    final cartState = ref.read(cartProvider);
    final hasItems = cartState.value?.items.isNotEmpty == true;

    if (hasItems) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClearCartPopup(
                onClearCart: () {
                  ref.read(cartProvider.notifier).reset();
                  Navigator.pop(context); // Close popup
                  Navigator.pop(context); // Go back
                },
                onSaveCart: () {
                  Navigator.pop(context); // Close popup
                  Navigator.pop(context); // Go back (keep cart)
                },
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  String _errorMessage(Object err) {
    if (err is UnauthenticatedException) return 'Session expired. Please log in again.';
    if (err is ForbiddenException)       return 'Access denied.';
    if (err is NetworkException)         return 'No internet connection. Please retry.';
    if (err is ServerException)          return 'Server error. Please try again later.';
    if (err is ConflictException)        return 'Something went wrong. Please retry.';
    if (err is ValidationException)      return err.message;
    return 'Something went wrong. Please retry.';
  }

  @override
  Widget build(BuildContext context) {
    final shopName = widget.laundry['name'] ?? 'Laundry';
    final merchantId = widget.laundry['id'] ?? widget.laundry['merchantId'] ?? 'test-merchant';

    ref.listen<AsyncValue<void>>(addToCartProvider, (previous, next) {
      next.when(
        data: (_) {
          if (previous is AsyncLoading) {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => CartScreen(
                merchantId: merchantId,
                merchantName: shopName,
              )
            ));
            ref.read(addToCartProvider.notifier).reset();
          }
        },
        error: (err, _) {
          if (previous is AsyncLoading) {
            final message = _errorMessage(err);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red)
            );
          }
        },
        loading: () {},
      );
    });

    final cartState = ref.watch(cartProvider);

    if (!_initialized) {
      if (cartState.value != null && cartState.value!.merchantId == merchantId) {
        for (final item in cartState.value!.items) {
          selectedQuantities[item.catalogItemId] = item.quantity;
        }
      }
      _initialized = true;
    }

    final isLoading = ref.watch(addToCartProvider) is AsyncLoading;
    final selectedItemsCount = selectedQuantities.values.fold(0, (sum, q) => sum + q);
    final totalAmount = kTempCatalogItems.fold(0.0, (sum, item) {
      final catalogItemId = item['catalogItemId'] as String;
      final quantity = selectedQuantities[catalogItemId] ?? 0;
      final unitPrice = item['unitPrice'] as double;
      return sum + (unitPrice * quantity);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Back Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(
                        onTap: () => _handleBack(context),
                      ),
                    ),
                  ),
                  
                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShopHeader(laundry: widget.laundry),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                const CustomSearchBar(hintText: 'Search'),
                                const SizedBox(height: 24),
                                const Text(
                                  'Items',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2D3A),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Items from Temp Catalog using native ServiceCard
                                ...kTempCatalogItems.map((item) {
                                  final catalogItemId = item['catalogItemId'] as String;
                                  final itemName = item['itemName'] as String;
                                  final unitPrice = item['unitPrice'] as double;
                                  final washType = item['washType'] as String;
                                  final quantity = selectedQuantities[catalogItemId] ?? 0;

                                  return ServiceCard(
                                    shopName: shopName,
                                    title: itemName,
                                    price: 'Rs. ${unitPrice.toStringAsFixed(2)}',
                                    description: washType,
                                    // Map wash type to right image
                                    imagePath: _getItemImage(itemName),
                                    quantity: quantity,
                                    onIncrement: () {
                                      setState(() {
                                        selectedQuantities[catalogItemId] = quantity + 1;
                                      });
                                    },
                                    onDecrement: quantity > 0 ? () {
                                      setState(() {
                                        selectedQuantities[catalogItemId] = quantity - 1;
                                      });
                                    } : null,
                                    onSetQuantity: (val) {
                                      setState(() {
                                        selectedQuantities[catalogItemId] = val;
                                      });
                                    },
                                  );
                                }),

                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // View Cart Bottom Bar
              if (selectedItemsCount > 0)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      height: 64,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D3A),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$selectedItemsCount items',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'LKR ${totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: isLoading ? null : () {
                                final selectedItems = kTempCatalogItems
                                    .where((item) => (selectedQuantities[item['catalogItemId']] ?? 0) > 0)
                                    .toList();

                                final requests = selectedItems.map((item) {
                                  return CartItemRequest(
                                    merchantName: shopName,
                                    catalogItemId: item['catalogItemId'],
                                    itemName: item['itemName'],
                                    washType: item['washType'],
                                    unitPrice: item['unitPrice'],
                                    quantity: selectedQuantities[item['catalogItemId']]!,
                                  );
                                }).toList();

                                final batchRequest = BatchCartRequest(
                                  merchantName: shopName,
                                  items: requests,
                                );
                                
                                // Wipe and Sync overrides the entire cart!
                                ref.read(addToCartProvider.notifier).syncItems(merchantId, batchRequest);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0062FF),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                elevation: 0,
                              ),
                              child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Row(
                                children: [
                                  Text(
                                    'View Cart',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getItemImage(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('shirt')) {
      if (lowerName.contains('formal')) return 'assets/laundry_items/Formal Shirt.jpeg';
      return 'assets/laundry_items/shirt.jpg';
    }
    if (lowerName.contains('t shirt') || lowerName.contains('t-shirt')) {
      return 'assets/laundry_items/t shirts.jpg';
    }
    if (lowerName.contains('trousers') || lowerName.contains('trouser')) {
      if (lowerName.contains('2')) return 'assets/laundry_items/trouser 2.jpg';
      return 'assets/laundry_items/Trousers.jpg';
    }
    if (lowerName.contains('jeans')) return 'assets/laundry_items/jeans.jpg';
    if (lowerName.contains('shorts')) return 'assets/laundry_items/Shorts.jpg';
    if (lowerName.contains('suit')) {
      if (lowerName.contains('s')) return 'assets/laundry_items/Suits.jpg';
      return 'assets/laundry_items/Suit.avif';
    }
    if (lowerName.contains('saree')) {
      if (lowerName.contains('2')) return 'assets/laundry_items/saree (2).jpg';
      return 'assets/laundry_items/Saree.jpg';
    }
    if (lowerName.contains('frock')) {
      if (lowerName.contains('2')) return 'assets/laundry_items/frock 2.jpg';
      if (lowerName.contains('3')) return 'assets/laundry_items/frock 3.jpg';
      return 'assets/laundry_items/frock 1.jpg';
    }
    if (lowerName.contains('bedsheet') || lowerName.contains('bed sheet')) {
      return 'assets/laundry_items/Bedsheet.jpg';
    }
    if (lowerName.contains('jacket')) return 'assets/laundry_items/jacket.jpg';
    if (lowerName.contains('under')) return 'assets/laundry_items/Underclothes.jpeg';
    return 'assets/images/laundry 1.png';
  }
}
