import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api/direction_service.dart';
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

final orderDetailsProvider = FutureProvider.family<PlaceOrderResponse, String>((ref, orderId) async {
  final service = ref.read(orderApiServiceProvider);
  return service.getOrderById(orderId);
});

final orderStatusPollingProvider = StreamProvider.family<PlaceOrderResponse, String>((ref, orderId) async* {
  final service = ref.read(orderApiServiceProvider);
  
  // Initial fetch
  try {
    final initial = await service.getOrderById(orderId);
    yield initial;
  } catch (e) {
    // Optionally log error
  }

  // Polling loop
  while (true) {
    await Future.delayed(const Duration(minutes: 1));
    try {
      final response = await service.getOrderById(orderId);
      yield response;
      
      // Stop polling if order is in a terminal state
      if (['DELIVERED', 'CANCELLED', 'REFUNDED'].contains(response.status.toUpperCase())) {
        break;
      }
    } catch (e) {
      // Continue polling even on error, maybe with exponential backoff if needed
      // for now, just keep trying every 20s
    }
  }
});

final directionServiceProvider = Provider((ref) => DirectionService());

final directionProvider = FutureProvider.family<RouteResponse, RouteRequest>((ref, request) async {
  final service = ref.read(directionServiceProvider);
  return service.getRoute(request.origin, request.destination);
});

class RouteRequest {
  final LatLng origin;
  final LatLng destination;
  RouteRequest(this.origin, this.destination);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouteRequest &&
          other.origin == origin &&
          other.destination == destination);

  @override
  int get hashCode => origin.hashCode ^ destination.hashCode;
}
