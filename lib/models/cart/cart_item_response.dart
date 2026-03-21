class CartItemResponse {
  final String id;
  final String catalogItemId;
  final String itemName;
  final String washType;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  CartItemResponse({
    required this.id,
    required this.catalogItemId,
    required this.itemName,
    required this.washType,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    return CartItemResponse(
      id: json['id'] as String,
      catalogItemId: json['catalogItemId'] as String,
      itemName: json['itemName'] as String,
      washType: json['washType'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}
