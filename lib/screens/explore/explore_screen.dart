import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/firebase/merchant_firebase_service.dart';
import 'widgets/shop_card.dart';
import '../home/widgets/home_top_bar.dart';
import '../../widgets/input_fields/custom_search_bar.dart';
import '../../widgets/buttons/back_button.dart';
import '../home/widgets/nav_bar.dart';
import '../search/search_screen.dart';
import '../account/account_screen.dart';
import '../cart/cart_screen.dart';
import '../../get_location/location_service.dart';
import '../home/home_screen.dart';
import '../../../providers/merchant/merchant_list_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String _location = 'Nugegoda, Sri Lanka';
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    final String? location = await _locationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() => _location = location);
    }
  }

  /// Converts a [MerchantWithDistance] to the [ShopCard] map format.
  Map<String, dynamic> _toShopCardMap(MerchantWithDistance item) {
    final m = item.merchant;
    return {
      'id': m.uid,
      'merchantId': m.merchantId,
      'name': m.outletName.isNotEmpty ? m.outletName : 'Laundry',
      'image': m.outletLogo?.isNotEmpty == true
          ? m.outletLogo
          : 'assets/images/laundry shop.png',
      'isNetworkImage': m.outletLogo?.isNotEmpty == true,
      'fee': 'Contact for pricing',
      'time': item.distanceLabel.isNotEmpty ? item.distanceLabel : 'Varies',
      'likes': m.city.isNotEmpty ? m.city : '—',
      'status': m.isActive ? null : 'Closed',
      'statusColor': Colors.red,
      'address': m.outletAddress,
      'menuDocument': m.menuDocument ?? '',
      'logo': m.outletLogo,
      'lat': m.location?.lat,
      'lng': m.location?.lng,
      'phone': m.managerPhone,
      'operatingHours': m.operatingHours.map((h) => {
        'day': h.day,
        'isOpen': h.isOpen,
        'openTime': h.openTime,
        'closeTime': h.closeTime,
      }).toList(),
      'services': const <Map<String, dynamic>>[],
    };
  }

  @override
  Widget build(BuildContext context) {
    final merchantsAsync = ref.watch(nearbyMerchantsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(onTap: () => Navigator.pop(context)),
              ),
            ),

            // Location Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: HomeTopBar(
                location: _location,
                onLocationTap: _fetchLocation,
                contentColor: Colors.black,
              ),
            ),

            // Search + title row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const CustomSearchBar(hintText: 'Search'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nearby Laundries',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh,
                            color: Color(0xFF2688EA)),
                        tooltip: 'Refresh',
                        onPressed: () =>
                            ref.invalidate(nearbyMerchantsProvider),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Merchant list
            Expanded(
              child: merchantsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load laundries.\nPlease check your connection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(nearbyMerchantsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.store_outlined,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'No laundries found nearby.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ShopCard(
                          laundry: _toShopCardMap(items[index]));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const SearchScreen()));
          } else if (index == 2) {
            // already here
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartScreen()));
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AccountScreen()));
          }
        },
      ),
    );
  }
}
