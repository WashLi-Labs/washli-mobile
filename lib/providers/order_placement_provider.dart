import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order/place_order_request.dart';
import '../models/order/place_order_response.dart';
import '../services/api/order_api_service.dart';
import '../services/api/api_exception.dart';

final orderApiServiceProvider = Provider((ref) => OrderApiService());

class OrderPlacementNotifier extends AsyncNotifier<PlaceOrderResponse?> {
  late final OrderApiService _orderApiService;

  @override
  FutureOr<PlaceOrderResponse?> build() {
    _orderApiService = ref.read(orderApiServiceProvider);
    return null;
  }

  Future<PlaceOrderResponse> placeOrder(PlaceOrderRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _orderApiService.placeOrder(request);
      state = AsyncData(response);
      return response;
    } catch (e, st) {
      if (e is ApiException) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(NetworkException(e.toString()), st);
      }
      rethrow;
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final orderPlacementProvider =
    AsyncNotifierProvider<OrderPlacementNotifier, PlaceOrderResponse?>(
  OrderPlacementNotifier.new,
);
