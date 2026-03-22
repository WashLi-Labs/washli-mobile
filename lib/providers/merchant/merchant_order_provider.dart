import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api/merchant_api_service.dart';
import '../../models/order/place_order_response.dart';

final merchantApiServiceProvider = Provider((ref) => MerchantApiService());

final merchantOrdersProvider = FutureProvider.family<List<PlaceOrderResponse>, String>((ref, status) async {
  final apiService = ref.watch(merchantApiServiceProvider);
  return apiService.getMerchantOrders(status);
});

// Helper provider for pending orders (status PLACED)
final merchantPendingOrdersProvider = Provider((ref) {
  return ref.watch(merchantOrdersProvider('PLACED'));
});

// Provider for merchant stats
final merchantStatsProvider = Provider((ref) {
  final pending = ref.watch(merchantOrdersProvider('PLACED')).value?.length ?? 0;
  // Others can be added as needed
  return {
    'pending': pending,
  };
});
