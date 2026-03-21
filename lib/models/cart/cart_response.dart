import 'cart_item_response.dart';

class CartResponse {
  final String id;
  final String merchantId;
  final String merchantName;
  final String status;
  final double itemsTotal;
  final List<CartItemResponse> items;

  CartResponse({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.status,
    required this.itemsTotal,
    required this.items,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      id: json['id'] as String,
      merchantId: json['merchantId'] as String,
      merchantName: json['merchantName'] as String,
      status: json['status'] as String,
      itemsTotal: (json['itemsTotal'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
