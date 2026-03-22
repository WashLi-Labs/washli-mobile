import 'package:flutter/material.dart'; 
import 'widgets/action_card.dart'; 
import 'widgets/category_list.dart'; 
import 'widgets/home_header.dart'; 
import 'widgets/nav_bar.dart'; 
import 'widgets/nearby_laundry_card.dart'; 
import 'widgets/active_order_card.dart'; // Import ActiveOrderCard
import '../search/search_screen.dart'; 
import '../explore/explore_screen.dart'; 
import '../account/account_screen.dart'; 
import '../cart/cart_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import '../../../providers/user_provider.dart'; 
import '../../../providers/active_order_provider.dart'; // Import activeOrderProvider
import '../../utils/alerts/error_alerts/location_enable_popup.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends ConsumerStatefulWidget { 
 final String userName; 

 const HomeScreen({ 
 super.key, 
 this.userName = "James", 
 }); 

 @override 
 ConsumerState<HomeScreen> createState() => _HomeScreenState(); 
} 

class _HomeScreenState extends ConsumerState<HomeScreen> { 
 int _selectedIndex = 0; 
 String? _firstName; 

 @override 
 void initState() { 
 super.initState(); 
 _loadUserName(); 
 _checkLocationStatus();
 } 

  Future<void> _checkLocationStatus() async {
    // Check if location services are enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled && mounted) {
      LocationEnablePopup.show(context);
    }
  }

 Future<void> _loadUserName() async { 
 final prefs = await SharedPreferences.getInstance(); 
 final firstName = prefs.getString('firstName'); 

 if (firstName != null && mounted) { 
 ref.read(userProvider.notifier).updateProfile(name: firstName); 
 } 
 } 

 void _onItemTapped(int index) { 
 if (index == 1) { 
 Navigator.push( 
 context, 
 MaterialPageRoute(builder: (context) => const SearchScreen()), 
 ).then((_) { 
 setState(() { 
 _selectedIndex = 0; 
 }); 
 ref.invalidate(activeOrderProvider); // Refresh active order
 }); 
 } else if (index == 2) { 
 Navigator.push( 
 context, 
 MaterialPageRoute(builder: (context) => const ExploreScreen()), 
 ).then((_) { 
 setState(() { 
 _selectedIndex = 0; 
 }); 
 ref.invalidate(activeOrderProvider); // Refresh active order
 }); 
 } else if (index == 3) { 
 Navigator.push( 
 context, 
 MaterialPageRoute(builder: (context) => const CartScreen()), 
 ).then((_) { 
 setState(() { 
 _selectedIndex = 0; 
 }); 
 ref.invalidate(activeOrderProvider); // Refresh active order
 }); 
 } else if (index == 4) { 
 Navigator.push( 
 context, 
 MaterialPageRoute(builder: (context) => AccountScreen(role: "Customer")), 
 ).then((_) { 
 setState(() { 
 _selectedIndex = 0; 
 }); 
 _loadUserName(); 
 ref.invalidate(activeOrderProvider); // Refresh active order
 }); 
 } else { 
 setState(() { 
 _selectedIndex = index; 
 }); 
 } 
 } 

 @override 
 Widget build(BuildContext context) { 
 final user = ref.watch(userProvider); 
 final activeOrderAsync = ref.watch(activeOrderProvider); // Watch active order
 final headerHeight = MediaQuery.of(context).size.height * 0.45; 

 return Scaffold( 
 backgroundColor: Colors.white, 
 body: Stack( 
 children: [ 
 // Scrollable Content 
 SingleChildScrollView( 
 child: Column( 
 children: [ 
 // Spacing for Static Header and Action Card intersection 
 SizedBox(height: headerHeight + 60), 

 // Categories 
 const CategoryList(), 

 const SizedBox(height: 20),

 // Active Order Card (Conditional)
 activeOrderAsync.when(
   data: (order) => order != null 
     ? Padding(
         padding: const EdgeInsets.symmetric(horizontal: 24),
         child: ActiveOrderCard(order: order),
       )
     : const SizedBox.shrink(),
   loading: () => const SizedBox.shrink(), // Or a small loading indicator
   error: (_, __) => const SizedBox.shrink(),
 ),

 const SizedBox(height: 30), 

 // Nearby Laundries 
 const NearbyLaundryCard(), 

 const SizedBox(height: 100), // Bottom padding 
 ], 
 ), 
 ), 

 // Static Header 
 HomeHeader(userName: user.name ?? widget.userName), 

 // Static Action Card Positioning 
 Positioned( 
 top: headerHeight - 50, // Half in, half out 
 left: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.85)) / 2, // Centered 
 child: const ActionCard(), 
 ), 
 ], 
 ), 

 // Bottom Navigation Bar Placeholder for completeness (Optional based on screenshot) 
 extendBody: true, // Allows body to extend behind the floating navbar 
 bottomNavigationBar: NavBar( 
 selectedIndex: _selectedIndex, 
 onItemTapped: _onItemTapped, 
 ), 
 ); 
 } 

}
