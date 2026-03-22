import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../widgets/buttons/back_button.dart';
import '../merchant_home/widgets/merchant_nav_bar.dart';
import 'widgets/order_card.dart';
import '../merchant_activity/activities/widgets/order_details/order_popup.dart';
import '../merchant_activity/activities/activities.dart';
import '../dashboard/dashboard.dart';
import '../../account/account_screen.dart';
import '../../../providers/merchant/merchant_order_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedIndex = 1; // Orders tab

  String _getTimeAgo(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final difference = DateTime.now().difference(dateTime);
      if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
      if (difference.inHours < 24) return '${difference.inHours} hours ago';
      return DateFormat('MMM dd').format(dateTime);
    } catch (_) {
      return 'Recently';
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else if (index == 4) {
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
        final pendingOrdersAsync = ref.watch(merchantOrdersProvider('PLACED'));

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
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
                      const SizedBox(width: 32),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => ref.invalidate(merchantOrdersProvider('PLACED')),
                    child: pendingOrdersAsync.when(
                      data: (orders) {
                        if (orders.isEmpty) {
                          return const Center(child: Text('No pending orders.'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: orders.length + 1, // Header + list
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Text(
                                  'Pending Orders',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2D3A),
                                  ),
                                ),
                              );
                            }
                            final order = orders[index - 1];
                            final itemsDesc = order.items
                                .map((i) => '${i.itemName} x ${i.quantity}') // Omitting washType as requested
                                .join(', ');

                            return OrderCard(
                              orderId: order.orderId,
                              timeAgo: _getTimeAgo(order.createdAt),
                              orderDescription: itemsDesc,
                              status: 'Pending', // Status is PLACED, but show as Pending in UI
                              onTap: () => OrderPopup.show(
                                context, 
                                order: order,
                                showActions: true,
                                role: "Merchant",
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error: $err')),
                    ),
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
