import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:washli_mobile/screens/explore/shop/widgets/service_popup.dart';
import 'package:washli_mobile/widgets/buttons/add_button.dart';

class ServiceCard extends StatelessWidget {
  final String shopName;
  final String title;
  final String price;
  final String description;
  final String imagePath;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final ValueChanged<int>? onSetQuantity;

  const ServiceCard({
    super.key,
    required this.shopName,
    required this.title,
    required this.price,
    required this.description,
    required this.imagePath,
    this.quantity = 0,
    this.onIncrement,
    this.onDecrement,
    this.onSetQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final isAdded = quantity > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    AddButton(
                      isCounterMode: isAdded,
                      count: quantity,
                      onIncrement: onIncrement ?? () {},
                      onDecrement: onDecrement ?? () {},
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.transparent,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Stack(
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
                                  child: ServicePopup(
                                    shopName: shopName,
                                    title: title,
                                    price: price,
                                    description: description,
                                    imagePath: imagePath,
                                    initialQuantity: quantity,
                                    onQuantityChanged: onSetQuantity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  "Fee : $price",
                   style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                     color: Color(0xFF2D2D3A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

