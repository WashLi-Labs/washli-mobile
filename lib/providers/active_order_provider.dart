import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order/place_order_response.dart';
import '../services/api/order_api_service.dart';

/// Fetches the user's latest active order on every provider invalidation.
/// An "active" order is anything that is NOT COMPLETED or CANCELLED.
final activeOrderProvider = FutureProvider<PlaceOrderResponse?>((ref) async {
  final service = OrderApiService();
  final orders = await service.getOrders();

  // Filter out completed / cancelled
  final active = orders.where((o) {
    final s = o.status.toUpperCase();
    return s != 'COMPLETE' && s != 'COMPLETED' && s != 'CANCELLED';
  }).toList();

  if (active.isEmpty) return null;

  // Return the most recently created one
  active.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return active.first;
});
