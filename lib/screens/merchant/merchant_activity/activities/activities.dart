import 'package:flutter/material.dart';
import '../../../../widgets/buttons/back_button.dart';
import '../../merchant_home/widgets/merchant_nav_bar.dart';
import 'widgets/pending.dart';
import 'widgets/inprogress.dart';
import 'widgets/completed.dart';
import 'widgets/canceled.dart';
import '../../orders/orders.dart';
import '../../dashboard/dashboard.dart';
import '../../../account/account_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 2; // Activities tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    if (index == 0) {
      // Home tab - pop back to MerchantHomeScreen
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 1) {
      // Orders tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: CustomBackButton(onTap: () => Navigator.pop(context)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Your activities',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFF007BFF),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              indicatorColor: const Color(0xFF007BFF),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
                Tab(text: 'Canceled'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  PendingActivities(),
                  InProgressActivities(),
                  CompletedActivities(),
                  CanceledActivities(),
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
