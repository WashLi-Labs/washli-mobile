import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washli_mobile/providers/cart_provider.dart';
import 'package:washli_mobile/screens/cart/cart_screen.dart';
import 'package:washli_mobile/screens/cart/widgets/clear_cart_popup.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/input_fields/custom_search_bar.dart';
import '../../../services/menu_items_service.dart';
import 'widgets/service_card.dart';
import 'widgets/shop_header.dart';

class ShopDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> laundry;

  const ShopDetailsScreen({super.key, required this.laundry});

  void _handleBack(BuildContext context, WidgetRef ref) {
    final cart = ref.read(cartProvider);
    if (cart.items.isNotEmpty) {
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
                  ref.read(cartProvider.notifier).clearCart();
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final shopName = laundry['name'] ?? 'Laundry';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context, ref);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Back Button (Fixed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(
                        onTap: () => _handleBack(context, ref),
                      ),
                    ),
                  ),
                  
                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shop Header (Image + Details)
                          ShopHeader(laundry: laundry),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),

                                // Search Bar
                                const CustomSearchBar(
                                  hintText: 'Search',
                                ),

                                const SizedBox(height: 24),

                                // Items Header
                                const Text(
                                  'Items',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2D3A),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Items loaded from Excel menuDocument
                                _MenuItemsList(laundry: laundry),

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
              if (cart.items.isNotEmpty)
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
                                  '${cart.totalItems} items',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'LKR ${cart.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const CartScreen()),
                                );
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
                              child: const Row(
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
}

// ─────────────────────────────────────────────────────────────
// Menu items loaded from the Excel menuDocument
// ─────────────────────────────────────────────────────────────

class _MenuItemsList extends StatefulWidget {
  final Map<String, dynamic> laundry;
  const _MenuItemsList({required this.laundry});

  @override
  State<_MenuItemsList> createState() => _MenuItemsListState();
}

class _MenuItemsListState extends State<_MenuItemsList> {
  late final Future<List<String>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    final url = widget.laundry['menuDocument'] as String? ?? '';
    _itemsFuture = url.isNotEmpty
        ? MenuItemsService.fetchItemNames(url)
        : Future.value([]);
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

    // Default fallback
    return 'assets/images/laundry 1.png';
  }

  @override
  Widget build(BuildContext context) {
    final shopName = widget.laundry['name'] as String? ?? 'Laundry';

    return FutureBuilder<List<String>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No items available for this laundry.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: items
              .map(
                (itemName) => ServiceCard(
                  shopName: shopName,
                  title: itemName,
                  price: 'Contact for pricing',
                  description: '',
                  imagePath: _getItemImage(itemName),
                ),
              )
              .toList(),
        );
      },
    );
  }
}


