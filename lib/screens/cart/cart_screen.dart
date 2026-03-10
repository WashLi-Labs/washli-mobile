import 'package:flutter/material.dart';
import '../../widgets/buttons/back_button.dart';
import 'widgets/cart_toggle.dart';
import 'choose_location/choose_location.dart';
import 'choose_location/location_bottom_sheet.dart';
import 'alternative_contact/alternative_contact.dart';
import 'widgets/cart_item_card.dart';
import 'split_my_bill/split_my_bill_section.dart';
import 'widgets/bill_summary.dart';
import 'widgets/payment_method_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
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
                          address: 'Fld Street',
                          subAddress: 'Nugegoda, Sri Lanka',
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
                      
                      const SizedBox(height: 16),

                      // Cart Items
                      const CartItemCard(
                        title: 'Shirts',
                        fee: 400.00,
                        type: 'Cotton',
                        service: 'Dry and wash',
                        initialQuantity: 2,
                      ),
                      // Add more items if needed, just one for now as per design
                      
                      const SizedBox(height: 16),
                      
                      // Split Bill
                       SplitMyBillSection(onTap: () {
                         // Split logic
                       }),
                       
                      const SizedBox(height: 20),
                      
                      // Bill Summary
                      const BillSummary(
                        subTotal: 1200.00,
                        deliveryFee: 150.00,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Payment Method
                      const PaymentMethodSelector(),
                      
                      const SizedBox(height: 20),
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
                  onPressed: () {
                    // Action logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0062FF),
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
