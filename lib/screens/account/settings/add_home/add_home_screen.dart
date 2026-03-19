import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_picker_screen.dart';
import 'widgets/recent_place_tile.dart';

class AddHomeScreen extends StatefulWidget {
  const AddHomeScreen({super.key});

  @override
  State<AddHomeScreen> createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock recent data
  final List<Map<String, String>> _recentPlaces = [
    {
      'name': 'NETWORXX (Pvt) Ltd..',
      'address': '22/5 Sujatha Ave, Dehiwala-Mount Lavinia',
      'distance': '2.8 mi',
    },
    {
      'name': 'DSSC - Club House',
      'address': 'WV59+8CF, Vidya Mawatha, Colombo',
      'distance': '1.7 mi',
    },
    {
      'name': 'LOLC Technologies Ltd',
      'address': '137 Rajagiriya Rd, Sri Jayawardenepura Kotte',
      'distance': '3.9 mi',
    },
  ];

  Future<void> _saveLocationAndPop(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('homeAddress', address);
    if (mounted) {
      Navigator.pop(context, address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Back + Search)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter home location',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Recent Places
                  ..._recentPlaces.map((place) => Column(
                    children: [
                      RecentPlaceTile(
                        name: place['name']!,
                        address: place['address']!,
                        distance: place['distance']!,
                        onTap: () => _saveLocationAndPop(place['address']!),
                      ),
                      const Divider(height: 1, indent: 70, endIndent: 20, color: Color(0xFFE5E7EB)),
                    ],
                  )),

                  // Set Location on Map Option
                  InkWell(
                    onTap: () async {
                      final selectedAddress = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPickerScreen(),
                        ),
                      );
                      
                      if (selectedAddress != null && selectedAddress.isNotEmpty && mounted) {
                        _saveLocationAndPop(selectedAddress);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF1A1A2E),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Set location on map',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
