import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/buttons/back_button.dart';
import 'widgets/payment_option_tile.dart';
import 'widgets/add_payment_bottom_sheet.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0; // 0: Cash, 1: Points, 2: Touch, 3: LankaQR

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
                      fontFamily: 'Outfit',
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
                    
                    const SizedBox(height: 20),
                    
                    // Add Payment Method Link
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddPaymentBottomSheet(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Add Payment Method",
                              style: TextStyle(
                                fontFamily: 'Outfit',
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
