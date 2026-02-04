import 'package:flutter/material.dart';

import 'home_top_bar.dart';
import '../../../get_location/location_service.dart';

class HomeHeader extends StatefulWidget {
  final String userName;

  const HomeHeader({
    super.key,
    required this.userName,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
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
    // Top 40% of the screen approximately
    final height = MediaQuery.of(context).size.height * 0.45;

    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF007BFF), // Cerulean Blue
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Location and Icons
                HomeTopBar(
                  location: _location,
                  onLocationTap: () {
                    // TODO: Handle location tap (e.g., refresh or open picker)
                    _fetchLocation();
                  },
                ),
                
                const SizedBox(height: 100),
                
                // Greeting and Washing Machine
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          '${widget.userName}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Washing Machine Image
          Positioned(
            right: -0,
            bottom: 40, 
            child: Image.asset(
              'assets/images/splash_bg.png',
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
