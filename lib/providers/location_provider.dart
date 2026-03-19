import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState {
  final LatLng? coordinates;
  final String address;
  final String subAddress;
  final bool isLoading;

  LocationState({
    this.coordinates,
    this.address = 'Select Location',
    this.subAddress = '',
    this.isLoading = false,
  });

  LocationState copyWith({
    LatLng? coordinates,
    String? address,
    String? subAddress,
    bool? isLoading,
  }) {
    return LocationState(
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
      subAddress: subAddress ?? this.subAddress,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LocationNotifier extends Notifier<LocationState> {
  @override
  LocationState build() {
    return LocationState();
  }

  void updateLocation({
    LatLng? coordinates,
    String? address,
    String? subAddress,
  }) {
    state = state.copyWith(
      coordinates: coordinates,
      address: address,
      subAddress: subAddress,
      isLoading: false,
    );
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

final locationProvider = NotifierProvider<LocationNotifier, LocationState>(() {
  return LocationNotifier();
});
