import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/merchant_nav_bar.dart';
import 'widgets/merchant_home_header.dart';
import 'widgets/merchant_action_card.dart';
import 'widgets/order_stats_card.dart';
import 'widgets/recent_activity_card.dart';
import '../merchant_activity/activities/activities.dart';
import '../orders/orders.dart';
import '../add_promotion/promotion.dart';
import '../dashboard/dashboard.dart';
import '../../account/account_screen.dart';
import '../../../providers/merchant_provider.dart';

class MerchantHomeScreen extends ConsumerStatefulWidget {
  const MerchantHomeScreen({super.key});

  @override
  ConsumerState<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends ConsumerState<MerchantHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load merchant profile on first mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(merchantProvider).merchant == null) {
        ref.read(merchantProvider.notifier).loadMerchantProfile();
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      ).then((_) => setState(() => _selectedIndex = 0));
      return;
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
      ).then((_) => setState(() => _selectedIndex = 0));
      return;
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      ).then((_) => setState(() => _selectedIndex = 0));
      return;
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen(role: 'Merchant')),
      ).then((_) => setState(() => _selectedIndex = 0));
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(merchantProvider);
    final merchantName =
        profileState.merchant?.outletName ?? 'Fresh Wash\nLaundry';

    // Show error as SnackBar and clear it afterwards
    ref.listen<MerchantState>(merchantProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(merchantProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      MerchantHomeHeader(merchantName: merchantName),

                      // Spacing for Action Card intersection
                      const SizedBox(height: 60),

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
                              childAspectRatio: 1.45,
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

                      const SizedBox(height: 120),
                    ],
                  ),

                  // Action Card Positioning
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.45 - 40,
                    left: (MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width * 0.85)) /
                        2,
                    child: MerchantActionCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PromotionScreen()),
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
