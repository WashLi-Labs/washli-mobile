import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washli_mobile/providers/cart_provider.dart';
import 'package:washli_mobile/providers/location_provider.dart';
import '../../widgets/buttons/back_button.dart';
import 'widgets/cart_toggle.dart';
import 'choose_location/choose_location.dart';
import 'choose_location/location_bottom_sheet.dart';
import 'alternative_contact/alternative_contact.dart';
import 'widgets/cart_item_card.dart';
import 'split_my_bill/split_my_bill_section.dart';
import 'widgets/bill_summary.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/clear_cart_popup.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isPickup = true;

  void _showLocationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final locState = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  if (cart.items.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
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
                                      Navigator.pop(context);
                                    },
                                    onSaveCart: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Clear Cart',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Toggle
                      CartToggle(
                        isPickup: _isPickup,
                        onToggle: (val) => setState(() => _isPickup = val),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Location Selector
                      if (_isPickup)
                        LocationSelector(
                          address: locState.address,
                          subAddress: locState.subAddress,
                          onTap: _showLocationSheet,
                        )
                      else
                        LocationSelector(
                          address: "I'll pickup myself",
                          subAddress: '', // Empty or hide
                          onTap: _showLocationSheet,
                        ),
                        
                      const SizedBox(height: 12),

                      // Alternative Contact - Present in both modes based on design image
                      const AlternativeContact(),
                      
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                      const SizedBox(height: 24),

                      if (cart.items.isNotEmpty) ...[
                        // Cart Items
                        ...cart.items.map((item) => CartItemCard(
                          title: item.title,
                          fee: item.price,
                          type: 'Laundry', // Fixed type for now or derive from item
                          service: item.description,
                          initialQuantity: item.quantity,
                        )),
                        
                        // Split Bill
                         SplitMyBillSection(onTap: () {
                           // Split logic
                         }),
                         
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                        const SizedBox(height: 24),
                        
                        // Bill Summary
                        BillSummary(
                          subTotal: cart.totalAmount,
                          deliveryFee: 150.00,
                        ),
                        
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                        const SizedBox(height: 24),
                        
                        // Payment Method
                        const PaymentMethodSelector(),
                        
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                        const SizedBox(height: 24),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.remove_shopping_cart_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Your cart is empty',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: cart.items.isEmpty ? null : () {
                    // Action logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0062FF),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _isPickup ? 'Confirm Delivery Location' : 'Self Pickup Your Order',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
