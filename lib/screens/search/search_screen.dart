import 'package:flutter/material.dart';
import '../home/widgets/home_top_bar.dart';
import '../home/widgets/nav_bar.dart';
import '../../widgets/input_fields/custom_search_bar.dart';
import '../../widgets/buttons/back_button.dart';
import '../../get_location/location_service.dart';
import '../explore/explore_screen.dart';
import '../account/account_screen.dart';
import '../payment/payment_screen.dart';
import '../cart/cart_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class Laundry {
  final String name;
  final String location;
  final String imagePath;

  Laundry({required this.name, required this.location, required this.imagePath});
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final int _selectedIndex = 1; // Search tab index
  String _location = "Nugegoda, Sri Lanka"; // Default location
  final LocationService _locationService = LocationService();
  String _searchQuery = "";

  final List<Laundry> _allLaundries = [
    Laundry(name: "Laundry Mirihana", location: "Mirihana", imagePath: "assets/images/shop1.jpg"),
    Laundry(name: "Clean & Shine", location: "Nugegoda", imagePath: "assets/images/shop1.jpg"),
    Laundry(name: "Quick Wash Hub", location: "Pagoda Road", imagePath: "assets/images/shop1.jpg"),
    Laundry(name: "City Laundromat", location: "Stanley Tilakaratne Mawatha", imagePath: "assets/images/shop1.jpg"),
    // Add more mock data as needed
  ];


  Widget _buildSearchResults() {
    final results = _allLaundries
        .where((laundry) =>
            laundry.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            laundry.location.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No laundries found',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final laundry = results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  laundry.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    laundry.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    laundry.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    String? location = await _locationService.getCurrentLocation();
    if (location != null) {
      if (mounted) {
        setState(() {
          _location = location;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context); // Go back to Home
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExploreScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    } else if (index == 4) {
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreen()),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: HomeTopBar(
                location: _location,
                onLocationTap: _fetchLocation,
                contentColor: Colors.black,
              ),
            ),
            

            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: CustomSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Results or Empty State
            Expanded(
              child: _searchQuery.isEmpty
                  ? Column(
                      children: [
                        // Recent Searches Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Recent Searches',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Empty State for Recent Searches
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF), // Light blue background
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/laundry 1.png',
                                  height: 120,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No recent searches',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B4B4B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                                  child: Text(
                                    'Here you can access your recent search queries.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 80), // Bottom spacing
                      ],
                    )
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
