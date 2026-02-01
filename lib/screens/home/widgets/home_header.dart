import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String location;

  const HomeHeader({
    super.key,
    required this.userName,
    this.location = "Nugegoda, Sri Lanka",
  });

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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                    
                    // Notification Icon
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
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
                          '$userName!',
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
          
          // Washing Machine Image (3D Isometric)
          Positioned(
            right: -20,
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
