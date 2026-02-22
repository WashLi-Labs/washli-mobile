import 'package:flutter/material.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/input_fields/custom_search_bar.dart';
import 'widgets/service_card.dart';
import 'widgets/shop_header.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> laundry;

  const ShopDetailsScreen({super.key, required this.laundry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Back Button (Fixed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                          const SizedBox(height: 24),
                          
                          // Search Bar
                          const CustomSearchBar(
                            hintText: 'Search',
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Services Header
                          const Text(
                            'Services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Services List
                          if (laundry['services'] != null)
                            ...(laundry['services'] as List).map((service) {
                              return ServiceCard(
                                title: service['title'] ?? '',
                                price: service['price'] ?? '',
                                description: service['description'] ?? '',
                                imagePath: service['image'] ?? 'assets/images/laundry 1.png',
                              );
                            })
                          else
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "No services available\n(Please Hot Restart the App to load new data)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          
                          // Add bottom padding for better scrolling experience
                          const SizedBox(height: 20), 
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


