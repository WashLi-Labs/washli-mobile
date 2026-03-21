class PlaceOrderRequest {
  final String merchantId;
  final String pickupMode;
  final String pickupAddress;
  final String scheduledPickupTime;
  final String preferredProvider;

  const PlaceOrderRequest({
    required this.merchantId,
    required this.pickupMode,
    required this.pickupAddress,
    required this.scheduledPickupTime,
    required this.preferredProvider,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'pickupMode': pickupMode,
      'pickupAddress': pickupAddress,
      'scheduledPickupTime': scheduledPickupTime,
      'preferredProvider': preferredProvider,
    };
  }
}
