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
import '../../../home/home_screen.dart';
import '../../../search/search_screen.dart';
import '../../../explore/explore_screen.dart';
import '../../../cart/cart_screen.dart';
import '../../../home/widgets/nav_bar.dart';

class ActivitiesScreen extends StatefulWidget {
  final String role;
  const ActivitiesScreen({super.key, this.role = "Merchant"});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 2; // Activities tab for Merchant

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // For Customer, we set selectedIndex to a value that won't highlight any tab if not present
    if (widget.role == "Customer") {
      _selectedIndex = -1; // Or some other logic if needed
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    if (widget.role == "Merchant") {
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
    } else {
      // Customer Navigation
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExploreScreen()),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
      } else if (index == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen(role: "Customer")),
        );
      }
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
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.only(left: 8),
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
                children: [
                  PendingActivities(role: widget.role),
                  InProgressActivities(role: widget.role),
                  CompletedActivities(role: widget.role),
                  CanceledActivities(role: widget.role),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.role == "Merchant"
          ? MerchantNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )
          : NavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}
