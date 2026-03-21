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
  final String scheduledPickupTime;
  final String createdAt;
  final double itemsTotal;
  final double pickupDeliveryFee;
  final double serviceFee;
  final double grandTotal;
  final double? estimatedReturnFee;
  final List<PlaceOrderItemResponse> items;

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
    required this.scheduledPickupTime,
    required this.createdAt,
    required this.itemsTotal,
    required this.pickupDeliveryFee,
    required this.serviceFee,
    required this.grandTotal,
    this.estimatedReturnFee,
    required this.items,
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
    );
  }
}
