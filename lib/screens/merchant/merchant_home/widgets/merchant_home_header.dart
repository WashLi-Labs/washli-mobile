import 'package:flutter/material.dart';
import '../../../../get_location/location_service.dart';
import '../../../home/widgets/home_top_bar.dart';

class MerchantHomeHeader extends StatefulWidget {
  final String merchantName;

  const MerchantHomeHeader({super.key, required this.merchantName});

  @override
  State<MerchantHomeHeader> createState() => _MerchantHomeHeaderState();
}

class _MerchantHomeHeaderState extends State<MerchantHomeHeader> {
  String _location = "Nugegoda, Sri Lanka";
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
    final height = MediaQuery.of(context).size.height * 0.45;

    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF007BFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeTopBar(location: _location, onLocationTap: _fetchLocation),
                const SizedBox(height: 100),
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
                      '${widget.merchantName}!',
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
          ),
          // Washing Machine Image
          Positioned(
            right: 0,
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

