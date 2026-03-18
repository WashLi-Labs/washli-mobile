import 'package:flutter/material.dart';
import 'widgets/merchant_nav_bar.dart';
import 'widgets/merchant_home_header.dart';
import 'widgets/merchant_action_card.dart';
import 'widgets/order_stats_card.dart';
import 'widgets/recent_activity_card.dart';
import '../merchant_activity/activities/activities.dart';
import '../orders/orders.dart';
import '../add_promotion/promotion.dart';
import '../dashboard/dashboard.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({super.key});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
      return;
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
      ).then((_) {
        // Reset index to Home when returning from Activities if desired
        setState(() {
          _selectedIndex = 0;
        });
      });
      return;
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const MerchantHomeHeader(merchantName: "Fresh Wash\nLaundry"),

                // Spacing for Action Card intersection
                const SizedBox(height: 50),

                // Orders Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.45, // Adjust for card proportions
                        children: [
                          OrderStatsCard(
                            title: 'Pending Orders',
                            count: '5',
                            subtitle: 'Awaiting confirmation',
                            dotColor: Colors.orange,
                            onTap: () => _onItemTapped(1),
                          ),
                          OrderStatsCard(
                            title: 'In Progress',
                            count: '2',
                            subtitle: 'Being washing and Drying',
                            dotColor: Colors.blue,
                            onTap: () => _onItemTapped(1),
                          ),
                          OrderStatsCard(
                            title: 'Completed',
                            count: '4',
                            subtitle: 'Delivered Successfully',
                            dotColor: Colors.green,
                            onTap: () => _onItemTapped(1),
                          ),
                          OrderStatsCard(
                            title: 'Canceled',
                            count: '2',
                            subtitle: 'Marked as canceled',
                            dotColor: Colors.red,
                            onTap: () => _onItemTapped(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Recent Activity Section
                const RecentActivityCard(),

                const SizedBox(height: 120), // Bottom padding for navbar
              ],
            ),

            // Action Card Positioning
            Positioned(
              top: MediaQuery.of(context).size.height * 0.40 - 40,
              left:
                  (MediaQuery.of(context).size.width -
                      (MediaQuery.of(context).size.width * 0.75)) /
                  2,
              child: MerchantActionCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PromotionScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: MerchantNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
