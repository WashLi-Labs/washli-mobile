import 'cart_item_request.dart';

class BatchCartRequest {
  final String merchantName;
  final List<CartItemRequest> items;

  BatchCartRequest({
    required this.merchantName,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantName': merchantName,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
