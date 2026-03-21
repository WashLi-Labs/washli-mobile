import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../progress_screen/progress_screen.dart';
import '../../providers/payment_provider.dart';
import '../../providers/order_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/order/order_model.dart';
import '../../services/firebase/order_service.dart';
import '../explore/explore_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  final String merchantId;
  final String merchantName;

  const CartScreen({
    super.key,
    this.merchantId = '',
    this.merchantName = 'Laundry',
  });

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isPickup = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart(widget.merchantId);
    });
  }

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
    final cartState = ref.watch(cartProvider);
    final locState = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: cartState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    err.toString().replaceAll(RegExp(r'^[A-Za-z]+Exception: '), ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.read(cartProvider.notifier).loadCart(widget.merchantId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (cart) {
            final hasCart = cart != null && cart.items.isNotEmpty;
            return Column(
              children: [
                // Header Map
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
                      if (hasCart)
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
                                        onClearCart: () async {
                                          try {
                                            await ref.read(cartProvider.notifier).clearCart(widget.merchantId);
                                          } catch (e) { /* ignore */ }
                                          if (context.mounted) {
                                            Navigator.pop(context); // close popup
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => const ExploreScreen()),
                                              (route) => route.isFirst,
                                            );
                                          }
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
                          LocationSelector(
                            address: locState.address,
                            subAddress: locState.subAddress,
                            onTap: _showLocationSheet,
                          ),
                            
                          const SizedBox(height: 12),

                          // Alternative Contact
                          const AlternativeContact(),
                          
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                          const SizedBox(height: 24),

                          if (hasCart) ...[
                            // Cart Items mapped locally via CartItemCard parameters
                            ...cart.items.map((item) => CartItemCard(
                              cartItemId: item.id,
                              title: item.itemName,
                              fee: item.unitPrice,
                              type: 'Laundry',
                              service: item.washType,
                              initialQuantity: item.quantity,
                              onRemoveRequested: () {
                                if (cart.items.length == 1) {
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
                                              child: Container(color: Colors.black.withOpacity(0.3)),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ClearCartPopup(
                                            onClearCart: () async {
                                              try {
                                                await ref.read(cartProvider.notifier).clearCart(widget.merchantId);
                                              } catch (e) { /* ignore */ }
                                              if (context.mounted) {
                                                Navigator.pop(context); // close popup
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const ExploreScreen()),
                                                  (route) => route.isFirst,
                                                );
                                              }
                                            },
                                            onSaveCart: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  ref.read(cartProvider.notifier).deleteItem(item.id);
                                }
                              },
                            )),
                            
                            SplitMyBillSection(onTap: () {
                              // Split logic
                            }),
                            
                            const SizedBox(height: 24),
                            const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                            const SizedBox(height: 24),
                            
                            // Bill Summary
                            BillSummary(
                              subTotal: cart.itemsTotal,
                              deliveryFee: _isPickup ? 150.00 : 0.00,
                            ),
                            
                            const SizedBox(height: 24),
                            const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                            const SizedBox(height: 24),
                            
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
                
                // Bottom Action Button Container
                if (hasCart)
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAEFF3), 
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bound Location Preview Row
                        GestureDetector(
                          onTap: _showLocationSheet,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/location_pin.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(Color(0xFF2D2D3A), BlendMode.srcIn),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isPickup ? 'Picking from' : 'Delivering from',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D2D3A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      locState.subAddress.isEmpty ? locState.address : '${locState.address}, ${locState.subAddress}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // ORIGINAL Confirm Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (locState.address == 'Select Location' || locState.address == 'Loading location...') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please select a valid delivery/pickup location.')),
                                );
                                return;
                              }
                              
                              try {
                                final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
                                final deliveryFee = _isPickup ? 150.00 : 0.00;
                                
                                // Mapping to existing model
                                final List<CartItem> modelItems = cart.items.map((i) => CartItem(
                                  title: i.itemName,
                                  price: i.unitPrice,
                                  quantity: i.quantity,
                                  description: i.washType,
                                  imagePath: ''
                                )).toList();

                                final order = OrderModel(
                                  id: '',
                                  orderId: 'Generating...',
                                  timeAgo: 'Just now',
                                  orderDescription: '${cart.items.length} items from ${cart.merchantName}',
                                  userId: userId,
                                  shopName: cart.merchantName,
                                  items: modelItems,
                                  subTotal: cart.itemsTotal,
                                  deliveryFee: deliveryFee,
                                  total: cart.itemsTotal + deliveryFee,
                                  status: 'pending',
                                  paymentMethod: ref.read(paymentProvider).displayName,
                                  isPickup: _isPickup,
                                  address: locState.address,
                                  createdAt: DateTime.now(),
                                );
                                
                                final orderId = await ref.read(orderService).createOrder(order);
                                
                                // After DB creation reset memory
                                ref.read(cartProvider.notifier).reset();
                                
                                if (!mounted) return;
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProgressScreen(
                                      orderId: orderId, 
                                      isPickup: _isPickup,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error placing order: $e')),
                                );
                              }
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
                              _isPickup ? 'Place Order' : 'Self Deliver Your Order',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      )
    );
  }
}
