import '../../models/order/place_order_request.dart';
import '../../models/order/place_order_response.dart';
import 'api_client.dart';
import 'api_constants.dart';

class OrderApiService {
  final ApiClient _client = ApiClient();

  Future<PlaceOrderResponse> placeOrder(PlaceOrderRequest request) async {
    final url = '$kBaseUrl$kOrderPath/orders';
    final response = await _client.post(url, body: request.toJson(), accept: '*/*');
    return PlaceOrderResponse.fromJson(response as Map<String, dynamic>);
  }
}
