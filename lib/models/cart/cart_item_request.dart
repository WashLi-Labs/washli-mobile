class CartItemRequest {
  final String merchantName;
  final String catalogItemId;
  final String itemName;
  final String washType;
  final double unitPrice;
  final int quantity;

  CartItemRequest({
    required this.merchantName,
    required this.catalogItemId,
    required this.itemName,
    required this.washType,
    required this.unitPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantName': merchantName,
      'catalogItemId': catalogItemId,
      'itemName': itemName,
      'washType': washType,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }
}
