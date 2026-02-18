import 'package:flutter/material.dart';
import '../../data/laundry_data.dart';
import 'widgets/shop_card.dart';
import '../home/widgets/home_top_bar.dart';
import '../../widgets/input_fields/custom_search_bar.dart';
import '../../widgets/buttons/back_button.dart';
import '../home/widgets/nav_bar.dart';
import '../search/search_screen.dart';
import '../../get_location/location_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _location = "Nugegoda, Sri Lanka"; // Default location
  final LocationService _locationService = LocationService();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            
            // HomeTopBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: HomeTopBar(
                location: _location,
                onLocationTap: _fetchLocation,
                contentColor: Colors.black,
              ),
            ),

            // Content with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const CustomSearchBar(
                    hintText: 'Search',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nearby Laundries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: laundryData.length,
                itemBuilder: (context, index) {
                  final laundry = laundryData[index];
                  return ShopCard(laundry: laundry);
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
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
        },
      ),
    );
  }
}
//           ],
//         ),
//       ),
//       bottomNavigationBar: NavBar(
//         selectedIndex: 2,
//         onItemTapped: (index) {
//           if (index == 0) {
//             Navigator.pop(context);
//           } else if (index == 1) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const SearchScreen()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
