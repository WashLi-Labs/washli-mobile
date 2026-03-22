import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../../providers/merchant/merchant_order_provider.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  final String role;
  final int initialIndex;
  const ActivitiesScreen({
    super.key, 
    this.role = "Merchant",
    this.initialIndex = 0,
  });

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  int _selectedIndex = 2; // Activities tab for Merchant

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshOrders();
    });
  }

  void _refreshOrders() {
    ref.invalidate(merchantAllActiveOrdersProvider);
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
          MaterialPageRoute(builder: (context) => const AccountScreen()),
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
    // For Customer, we ensure selectedIndex is handled
    if (widget.role == "Customer" && _selectedIndex == 2) {
       _selectedIndex = -1;
    }
    
    final int tabCount = widget.role == "Customer" ? 3 : 4;

    return DefaultTabController(
      initialIndex: widget.initialIndex,
      length: tabCount,
      child: Scaffold(
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
                tabs: [
                  if (widget.role == "Merchant") const Tab(text: 'Pending'),
                  const Tab(text: 'In Progress'),
                  const Tab(text: 'Completed'),
                  const Tab(text: 'Canceled'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    if (widget.role == "Merchant") PendingActivities(role: widget.role),
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
      ),
    );
  }
}
