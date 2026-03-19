import 'package:flutter/material.dart';
import '../../../widgets/buttons/back_button.dart';
import '../merchant_home/widgets/merchant_nav_bar.dart';
import 'widgets/order_card.dart';
import '../merchant_activity/activities/widgets/order_details/order_popup.dart';
import '../merchant_activity/activities/activities.dart';
import '../dashboard/dashboard.dart';
import '../../account/account_screen.dart';

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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  OrderCard(
                    orderId: '#ORD-1523',
                    timeAgo: '2 minutes ago',
                    orderDescription: 'Order ID - ORD1523 - RS.3500.00',
                    status: 'Pending',
                    onTap: () => OrderPopup.show(context, showActions: true),
                  ),
                  OrderCard(
                    orderId: '#ORD-1523',
                    timeAgo: '10 minutes ago',
                    orderDescription: 'Order ID - ORD1523 - RS.3500.00',
                    status: 'Pending',
                    onTap: () => OrderPopup.show(context, showActions: true),
                  ),
                  OrderCard(
                    orderId: '#ORD-1523',
                    timeAgo: '2 minutes ago',
                    orderDescription: 'Order ID - ORD1523 - RS.3500.00',
                    status: 'Completed',
                    onTap: () => OrderPopup.show(context, showActions: false),
                  ),
                  OrderCard(
                    orderId: '#ORD-1523',
                    timeAgo: '2 minutes ago',
                    orderDescription: 'Order ID - ORD1523 - RS.3500.00',
                    status: 'In Progress',
                    onTap: () => OrderPopup.show(context, showActions: false),
                  ),
                ],
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
  }
}
