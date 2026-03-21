import '../../models/cart/cart_item_request.dart';
import '../../models/cart/batch_cart_request.dart';
import '../../models/cart/cart_item_response.dart';
import '../../models/cart/cart_response.dart';
import 'api_client.dart';
import 'api_constants.dart';

class CartApiService {
  final ApiClient _client = ApiClient();

  Future<void> clearCart(String merchantId) async {
    final url = '$kBaseUrl$kOrderPath/carts/$merchantId';
    await _client.delete(url, accept: '*/*');
  }

  Future<CartItemResponse> addItem(String merchantId, CartItemRequest request) async {
    final url = '$kBaseUrl$kOrderPath/carts/$merchantId/items';
    final response = await _client.post(url, body: request.toJson());
    return CartItemResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<List<CartItemResponse>> addItems(String merchantId, BatchCartRequest request) async {
    final url = '$kBaseUrl$kOrderPath/carts/$merchantId/items/batch';
    final response = await _client.post(url, body: request.toJson(), accept: 'application/json');
    return (response as List<dynamic>)
        .map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CartResponse> getCart(String merchantId) async {
    final url = '$kBaseUrl$kOrderPath/carts/$merchantId';
    final response = await _client.get(url);
    return CartResponse.fromJson(response as Map<String, dynamic>);
  }
}
