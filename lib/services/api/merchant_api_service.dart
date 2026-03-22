import 'api_client.dart';
import 'api_constants.dart';
import '../../models/order/place_order_response.dart';

class MerchantApiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<PlaceOrderResponse>> getMerchantOrders(String status) async {
    final response = await _apiClient.get('$kBaseUrl$kOrderPath/merchant/orders?status=$status');
    if (response is List) {
      return response.map((json) => PlaceOrderResponse.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> confirmOrder(String orderId) async {
    await _apiClient.post(
      '$kBaseUrl$kOrderPath/merchant/orders/$orderId/confirm',
      accept: '*/*',
    );
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    await _apiClient.post(
      '$kBaseUrl$kOrderPath/merchant/orders/$orderId/cancel',
      body: {'reason': reason},
      accept: '*/*',
    );
  }
}
