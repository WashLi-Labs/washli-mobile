import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../providers/location_provider.dart';
import '../../../get_location/location_service.dart';

// The Widget displayed on Cart Screen
class LocationSelector extends StatelessWidget {
  final String address;
  final String subAddress;
  final VoidCallback onTap;

  const LocationSelector({
    super.key,
    required this.address,
    required this.subAddress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEFF3), // Light blue-ish grey
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/location_pin.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF2D2D3A), // Dark text color
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    address,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  if (subAddress.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

// The Screen navigated to for choosing location
class ChooseLocationScreen extends ConsumerStatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  ConsumerState<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends ConsumerState<ChooseLocationScreen> {
  LatLng _currentLocation = const LatLng(6.8649, 79.8997); // Nugegoda approx
  String _currentAddress = 'Fld Street';
  String _currentSubAddress = 'Nugegoda, Sri Lanka';
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Initialize from provider synchronously before map render
    final locState = ref.read(locationProvider);
    if (locState.coordinates != null) {
      _currentLocation = locState.coordinates!;
      _currentAddress = locState.address;
      _currentSubAddress = locState.subAddress;
    } else {
      // If no coordinates in provider, fetch actual location to show
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToCurrentGpsLocation();
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateLocationState(LatLng latLng) async {
    setState(() {
      _currentLocation = latLng;
      _currentAddress = 'Loading...';
      _currentSubAddress = '';
    });
    final addressData = await LocationService().getAddressFromLatLng(latLng.latitude, latLng.longitude);
    if (mounted) {
      setState(() {
        _currentAddress = addressData['address']!;
        _currentSubAddress = addressData['subAddress']!;
      });
    }
  }

  void _goToCurrentGpsLocation() async {
    final position = await LocationService().getPosition();
    if (position != null) {
      final latLng = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      _updateLocationState(latLng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayAddress = _currentSubAddress.isEmpty ? _currentAddress : '$_currentAddress, $_currentSubAddress';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CustomBackButton(
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            padding: const EdgeInsets.only(bottom: 280),
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition position) {
              _currentLocation = position.target;
            },
            onCameraIdle: () {
              _updateLocationState(_currentLocation);
            },
          ),
          
          // Center Fixed Marker
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 280,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 22), // Offset so the pin tip is at exact center
                child: Icon(
                  Icons.location_on,
                  color: Color(0xFFEA4335), // Google Maps Red
                  size: 44,
                ),
              ),
            ),
          ),
          
          // Current Location FAB
          Positioned(
            bottom: 300,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'currentLocationFab',
              backgroundColor: Colors.white,
              onPressed: _goToCurrentGpsLocation,
              child: SvgPicture.asset(
                'assets/icons/current_location.svg',
                colorFilter: const ColorFilter.mode(Color(0xFF0062FF), BlendMode.srcIn),
              ),
            ),
          ),

          // Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirm Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Press "Confirm" if this Location is Correct',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Location Display Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEFF3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location_pin.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF2D2D3A),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            displayAddress,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Confirm location logic
                        ref.read(locationProvider.notifier).updateLocation(
                          coordinates: _currentLocation,
                          address: _currentAddress,
                          subAddress: _currentSubAddress,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0062FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // SafeArea padding
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
