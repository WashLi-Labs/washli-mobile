import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/buttons/back_button.dart';
import 'widgets/payment_option_tile.dart';
import 'widgets/add_payment_bottom_sheet.dart';

import 'add_card_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0; // 0: Cash, 1: Points, 2: Touch, 3: LankaQR
  final List<String> _addedCards = []; // Store nicknames of added cards

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.black,
                      
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PaymentOptionTile(
                      iconPath: "assets/icons/cash_payment.svg",
                      title: "Cash",
                      isSelected: _selectedPaymentMethod == 0,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 0;
                        });
                      },
                    ),
                    PaymentOptionTile(
                      iconPath: "assets/icons/points_payment.png",
                      title: "Points",
                      subtitle: "0",
                      isIconSvg: false,
                      isSelected: _selectedPaymentMethod == 1,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 1;
                        });
                      },
                    ),
                     PaymentOptionTile(
                      iconPath: "assets/icons/touch_payment.png",
                      title: "Touch",
                      isIconSvg: false,
                      isSelected: _selectedPaymentMethod == 2,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 2;
                        });
                      },
                    ),
                     PaymentOptionTile(
                      iconPath: "assets/icons/qr_payment.png",
                      title: "Pay with LANKAQR",
                      isIconSvg: false,
                      isSelected: _selectedPaymentMethod == 3,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 3;
                        });
                      },
                    ),
                    
                    // Added Cards
                    if (_addedCards.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "Saved Cards",
                          style: TextStyle(
                            
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._addedCards.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final String nickname = entry.value;
                        // Offset selection index for added cards (0-3 are default, 4+ are added cards)
                        final int selectionIndex = 4 + index; 
                        
                        return PaymentOptionTile(
                          iconPath: "assets/icons/card_payment_icon.png", // Or card_payment.svg if available/preferred
                          title: nickname,
                          subtitle: "**** **** **** ****", // Masked card placeholder
                          isIconSvg: false, // Assuming png for now based on file list
                          isSelected: _selectedPaymentMethod == selectionIndex,
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = selectionIndex;
                            });
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _addedCards.removeAt(index);
                                // Reset selection if the removed card was selected
                                if (_selectedPaymentMethod == selectionIndex) {
                                  _selectedPaymentMethod = 0; // Default to Cash
                                } else if (_selectedPaymentMethod > selectionIndex) {
                                    // Adjust selection index if a card before the selected one was removed
                                    _selectedPaymentMethod--;
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Card Removed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ],

                    const SizedBox(height: 20),
                    
                    // Add Payment Method Link
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: InkWell(
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddPaymentBottomSheet(),
                          );

                          if (result == "add_card") {
                            // Check limit
                            if (_addedCards.length >= 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("You can only add up to 3 cards."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Navigate to AddCardScreen
                            final newCardNickname = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(builder: (context) => const AddCardScreen()),
                            );

                            if (newCardNickname != null && newCardNickname.isNotEmpty) {
                              setState(() {
                                _addedCards.add(newCardNickname);
                              });
                              
                              // Success Popup/Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Card Added Successfully"),
                                  backgroundColor: Colors.green, // Requested green color
                                ),
                              );
                            }
                          } else if (result == "touch") {
                            // Handle Touch addition if needed
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Add Payment Method",
                              style: TextStyle(
                                
                                fontSize: 16,
                                color: Color(0xFF0057E6),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/add_icon_blue.svg",
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
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
