import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  
  // Default to Colombo, Sri Lanka
  LatLng _center = const LatLng(6.9271, 79.8612);
  bool _isLoading = false;
  String _currentAddress = "Move map to select location...";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _mapController.move(_center, 15.0);
      });
      _updateAddress(_center);
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _currentAddress = [
            if (p.street != null && p.street!.isNotEmpty) p.street,
            if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
            if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          ].where((e) => e != null).join(', ');
          
          if (_currentAddress.isEmpty) {
            _currentAddress = p.country ?? "Unknown location";
          }
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Unknown location";
      });
    }
  }

  void _onDone() async {
    setState(() => _isLoading = true);
    
    // Reverse geocode final center position
    final center = _mapController.camera.center;
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        center.latitude,
        center.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = [p.street, p.subLocality, p.locality].where((e) => e != null && e.isNotEmpty).join(', ');
        if (mounted) Navigator.pop(context, address);
        return;
      }
    } catch (e) {
       // Fallback
    }

    if (mounted) Navigator.pop(context, "Selected Location");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              onPositionChanged: (pos, hasGesture) {
                if (hasGesture) {
                  _updateAddress(pos.center);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.washli.washli_mobile',
              ),
            ],
          ),

          // Fixed Center Pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 36), // offset to point to center
              child: Icon(
                Icons.location_on,
                size: 44,
                color: Color(0xFF1A1A2E), // Match dark grey pin from design
              ),
            ),
          ),

          // Top Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: const Color(0xFF1A1A2E),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Search bar overlay (top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 64,
            right: 16,
            child: SafeArea(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E).withAlpha(220),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Search location',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet / Done Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Address preview
                  Text(
                    _currentAddress,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E7EB), // Light grey "Done" button per screenshot
                      foregroundColor: const Color(0xFF1A1A2E),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
