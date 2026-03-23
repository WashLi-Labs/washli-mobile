class PlaceOrderItemResponse {
  final String itemName;
  final String washType;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  const PlaceOrderItemResponse({
    required this.itemName,
    required this.washType,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  factory PlaceOrderItemResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderItemResponse(
      itemName: json['itemName'] as String,
      washType: json['washType'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

class DeliveryResponse {
  final String id;
  final String tripType;
  final String providerName;
  final String status;
  final double quotedFee;
  final String originAddress;
  final String destinationAddress;
  final double? latitude;
  final double? longitude;
  final String? jobId;

  const DeliveryResponse({
    required this.id,
    required this.tripType,
    required this.providerName,
    required this.status,
    required this.quotedFee,
    required this.originAddress,
    required this.destinationAddress,
    this.latitude,
    this.longitude,
    this.jobId,
  });

  factory DeliveryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryResponse(
      id: json['id'] as String,
      tripType: json['tripType'] as String,
      providerName: json['providerName'] as String,
      status: json['status'] as String,
      quotedFee: (json['quotedFee'] as num).toDouble(),
      originAddress: json['originAddress'] as String,
      destinationAddress: json['destinationAddress'] as String,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      jobId: json['jobId'] as String?,
    );
  }
}

class PlaceOrderResponse {
  final String orderId;
  final String customerId;
  final String status;
  final String customerName;
  final String merchantName;
  final String pickupMode;
  final String? returnMode;
  final String pickupAddress;
  final String merchantAddress;
  final double? latitude;
  final double? longitude;
  final String scheduledPickupTime;
  final String createdAt;
  final double itemsTotal;
  final double pickupDeliveryFee;
  final double serviceFee;
  final double grandTotal;
  final double? estimatedReturnFee;
  final List<PlaceOrderItemResponse> items;
  final List<DeliveryResponse> deliveries;

  const PlaceOrderResponse({
    required this.orderId,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.merchantName,
    required this.pickupMode,
    this.returnMode,
    required this.pickupAddress,
    required this.merchantAddress,
    this.latitude,
    this.longitude,
    required this.scheduledPickupTime,
    required this.createdAt,
    required this.itemsTotal,
    required this.pickupDeliveryFee,
    required this.serviceFee,
    required this.grandTotal,
    this.estimatedReturnFee,
    required this.items,
    this.deliveries = const [],
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponse(
      orderId: json['orderId'] as String,
      customerId: json['customerId'] as String,
      status: json['status'] as String,
      customerName: json['customerName'] as String,
      merchantName: json['merchantName'] as String,
      pickupMode: json['pickupMode'] as String,
      returnMode: json['returnMode'] as String?,
      pickupAddress: json['pickupAddress'] as String,
      merchantAddress: json['merchantAddress'] as String,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      scheduledPickupTime: json['scheduledPickupTime'] as String,
      createdAt: json['createdAt'] as String,
      itemsTotal: (json['itemsTotal'] as num).toDouble(),
      pickupDeliveryFee: (json['pickupDeliveryFee'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      estimatedReturnFee: json['estimatedReturnFee'] != null
          ? (json['estimatedReturnFee'] as num).toDouble()
          : null,
      items: (json['items'] as List<dynamic>)
          .map((e) => PlaceOrderItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveries: json['deliveries'] != null
          ? (json['deliveries'] as List<dynamic>)
              .map((e) => DeliveryResponse.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}
