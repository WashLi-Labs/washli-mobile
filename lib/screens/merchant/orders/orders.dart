import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/buttons/back_button.dart';
import '../merchant_home/widgets/merchant_nav_bar.dart';
import 'widgets/order_card.dart';
import '../merchant_activity/activities/widgets/order_details/order_popup.dart';
import '../merchant_activity/activities/activities.dart';
import '../dashboard/dashboard.dart';
import '../../account/account_screen.dart';
import 'package:washli_mobile/providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedIndex = 1; // Orders tab

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    if (index == 0) {
      // Home tab - pop back to MerchantHomeScreen
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 2) {
      // Activities tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
      );
    } else if (index == 3) {
      // Dashboard tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else if (index == 4) {
      // Account tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreen(role: "Merchant")),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final orderState = ref.watch(orderProvider);
        final allOrders = [...orderState.activeOrders, ...orderState.pastOrders];

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Custom Header matching screenshot with fix for overlap clash
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      CustomBackButton(onTap: () => Navigator.pop(context)),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Orders',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32), // Balancing the back button to keep title centered
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: allOrders.length,
                    itemBuilder: (context, index) {
                      final order = allOrders[index];
                      return OrderCard(
                        orderId: order.orderId,
                        timeAgo: order.timeAgo,
                        orderDescription: order.orderDescription,
                        status: order.status,
                        onTap: () => OrderPopup.show(
                          context, 
                          orderId: order.id,
                          showActions: order.status == 'Pending',
                          role: "Merchant",
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MerchantNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        );
      },
    );
  }
}
