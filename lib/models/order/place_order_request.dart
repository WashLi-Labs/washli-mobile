class PlaceOrderRequest {
  final String merchantId;
  final String pickupMode;
  final String pickupAddress;
  final String scheduledPickupTime;
  final String preferredProvider;
  final double latitude;
  final double longitude;

  const PlaceOrderRequest({
    required this.merchantId,
    required this.pickupMode,
    required this.pickupAddress,
    required this.scheduledPickupTime,
    required this.preferredProvider,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'pickupMode': pickupMode,
      'pickupAddress': pickupAddress,
      'scheduledPickupTime': scheduledPickupTime,
      'preferredProvider': preferredProvider,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
