import 'package:flutter/material.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location Dropdown (Mock)
                    // Location Dropdown (Mock)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // TODO: Handle location tap (e.g., refresh or open picker)
                          _fetchLocation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 160),
                                child: Text(
                                  _location,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Notification and Menu Icons
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              // TODO: Handle notification tap
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/home-icons/Bell.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8), // Adjusted spacing for padding
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              // TODO: Handle menu tap
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/home-icons/Unorder list.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                            color: Colors.white.withOpacity(0.9),
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
