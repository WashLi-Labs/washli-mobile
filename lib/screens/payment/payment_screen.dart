import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/buttons/back_button.dart';
import 'widgets/payment_option_tile.dart';
import 'widgets/add_payment_bottom_sheet.dart';

import 'add_card_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/wallet_provider.dart';
import '../../../providers/payment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final payment = ref.watch(paymentProvider);
    final paymentNotifier = ref.read(paymentProvider.notifier);
    
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
                    // Points Option
                    PaymentOptionTile(
                      iconPath: "assets/icons/points_payment.png",
                      title: "Points",
                      subtitle: wallet.pointsBalance.toStringAsFixed(0),
                      isIconSvg: false,
                      isSelected: payment.selectedType == PaymentType.points,
                      onTap: () {
                        paymentNotifier.selectMethod(PaymentType.points);
                      },
                    ),
                    // Touch Option
                    PaymentOptionTile(
                      iconPath: "assets/icons/touch_payment.png",
                      title: "Touch",
                      isIconSvg: false,
                      isSelected: payment.selectedType == PaymentType.touch,
                      onTap: () {
                        paymentNotifier.selectMethod(PaymentType.touch);
                      },
                    ),
                    // LankaQR Option
                    PaymentOptionTile(
                      iconPath: "assets/icons/qr_payment.png",
                      title: "Pay with LANKAQR",
                      isIconSvg: false,
                      isSelected: payment.selectedType == PaymentType.lankaQr,
                      onTap: () {
                        paymentNotifier.selectMethod(PaymentType.lankaQr);
                      },
                    ),
                    
                    // Saved Cards
                    if (payment.savedCards.isNotEmpty) ...[
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
                      ...payment.savedCards.map((nickname) {
                        return PaymentOptionTile(
                          iconPath: "assets/icons/card_payment_icon.png",
                          title: nickname,
                          subtitle: "**** **** **** ****",
                          isIconSvg: false,
                          isSelected: payment.selectedType == PaymentType.card && payment.selectedCardNickname == nickname,
                          onTap: () {
                            paymentNotifier.selectMethod(PaymentType.card, cardNickname: nickname);
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              paymentNotifier.removeCard(nickname);
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
                            if (payment.savedCards.length >= 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("You can only add up to 3 cards."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final newCardNickname = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(builder: (context) => const AddCardScreen()),
                            );

                            if (newCardNickname != null && newCardNickname.isNotEmpty) {
                              paymentNotifier.addCard(newCardNickname);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Card Added Successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
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
