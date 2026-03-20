import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_picker_screen.dart';
import 'widgets/recent_place_tile.dart';
import '../../../../widgets/buttons/back_button.dart';

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
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header (Back + Search)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  CustomBackButton(
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000), // black 4%
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter home location',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF007DFC),
                            size: 22,
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // List Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000), // black 2%
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
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
                            const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
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
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0F6FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF007DFC),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Set location on map',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A2E), // Primary dark color
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFFD1D5DB),
                                  size: 16,
                                )
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
          ],
        ),
      ),
    );
  }
}
