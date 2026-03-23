import '../../models/order/place_order_request.dart';
import '../../models/order/place_order_response.dart';
import 'api_client.dart';
import 'api_constants.dart';

class OrderApiService {
  final ApiClient _client = ApiClient();

  /// POST /order/orders — place a new order
  Future<PlaceOrderResponse> placeOrder(PlaceOrderRequest request) async {
    final url = '$kBaseUrl$kOrderPath/orders';
    final response = await _client.post(url, body: request.toJson(), accept: '*/*');
    return PlaceOrderResponse.fromJson(response as Map<String, dynamic>);
  }

  /// GET /order/orders?page=0&size=20 — list all orders for current user
  Future<List<PlaceOrderResponse>> getOrders() async {
    final url = '$kBaseUrl$kOrderPath/orders?page=0&size=20';
    final response = await _client.get(url, accept: '*/*');
    final list = response as List<dynamic>;
    return list
        .map((e) => PlaceOrderResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /order/orders/{orderId} — get a single order by ID
  Future<PlaceOrderResponse> getOrderById(String orderId) async {
    final url = '$kBaseUrl$kOrderPath/orders/$orderId';
    final response = await _client.get(url, accept: '*/*');
    return PlaceOrderResponse.fromJson(response as Map<String, dynamic>);
  }

  /// POST /order/webhooks/partner/{provider}/status — trigger a status update (TEMP for testing)
  Future<void> triggerStatusWebhook({
    required String provider,
    required String jobId,
    required String eventType,
  }) async {
    final url = '$kBaseUrl$kOrderPath/webhooks/partner/${provider.toLowerCase()}/status';
    final body = {
      'jobId': jobId,
      'eventType': eventType,
    };
    await _client.post(
      url,
      body: body,
      headers: {'X-PickMe-Signature': 'sha256=skip'},
      accept: '*/*',
    );
  }
}
