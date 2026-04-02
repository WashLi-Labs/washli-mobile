import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api/merchant_api_service.dart';
import '../../models/order/place_order_response.dart';

final merchantApiServiceProvider = Provider((ref) => MerchantApiService());

// Optimized provider that fetches all relevant statuses in parallel
final merchantAllActiveOrdersProvider = FutureProvider<List<PlaceOrderResponse>>((ref) async {
  final apiService = ref.watch(merchantApiServiceProvider);
  
  // Statuses to fetch
  final statuses = [
    'PLACED',
    'CONFIRMED',
    'PICKED_UP',
    'AT_LAUNDRY',
    'WASHING',
    'READY_FOR_RETURN',
    'WALK_IN_RETURN',
    'PARTNER_RETURN',
    'OUT_FOR_DELIVERY',
    'CANCELLED',
  ];

  // Fetch all statuses in parallel with individual error handling
  final results = await Future.wait(
    statuses.map((status) async {
      try {
        return await apiService.getMerchantOrders(status);
      } catch (e) {
        // Log individual status fetch failures but don't break the whole list
        print('Error fetching orders for status $status: $e');
        return <PlaceOrderResponse>[];
      }
    }),
  );
  
  // Flatten results into a single list
  return results.expand((orders) => orders).toList();
});

// Category-specific providers based on the new mapping
final merchantPendingOrdersProvider = Provider<AsyncValue<List<PlaceOrderResponse>>>((ref) {
  return ref.watch(merchantAllActiveOrdersProvider).whenData(
    (orders) => orders.where((o) => o.status == 'PLACED').toList()
  );
});

final merchantInProgressOrdersProvider = Provider<AsyncValue<List<PlaceOrderResponse>>>((ref) {
  final inProgressStatuses = ['CONFIRMED', 'PICKED_UP', 'AT_LAUNDRY', 'WASHING'];
  return ref.watch(merchantAllActiveOrdersProvider).whenData(
    (orders) => orders.where((o) => inProgressStatuses.contains(o.status)).toList()
  );
});

final merchantCompletedOrdersProvider = Provider<AsyncValue<List<PlaceOrderResponse>>>((ref) {
  final completedStatuses = [
    'READY_FOR_RETURN',
    'WALK_IN_RETURN',
    'PARTNER_RETURN',
    'OUT_FOR_DELIVERY',
    'DELIVERED'
  ];
  return ref.watch(merchantAllActiveOrdersProvider).whenData(
    (orders) => orders.where((o) => completedStatuses.contains(o.status)).toList()
  );
});

final merchantCanceledOrdersProvider = Provider<AsyncValue<List<PlaceOrderResponse>>>((ref) {
  return ref.watch(merchantAllActiveOrdersProvider).whenData(
    (orders) => orders.where((o) => o.status == 'CANCELLED').toList()
  );
});

// Provider for merchant stats used in Home Screen 
final merchantStatsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final allOrdersAsync = ref.watch(merchantAllActiveOrdersProvider);
  
  return allOrdersAsync.whenData((orders) {
    final completedStatuses = [
      'READY_FOR_RETURN',
      'WALK_IN_RETURN',
      'PARTNER_RETURN',
      'OUT_FOR_DELIVERY',
      'DELIVERED'
    ];
    
    final inProgressStatuses = ['CONFIRMED', 'PICKED_UP', 'AT_LAUNDRY', 'WASHING'];
    
    return {
      'pending': orders.where((o) => o.status == 'PLACED').length,
      'inprogress': orders.where((o) => inProgressStatuses.contains(o.status)).length,
      'completed': orders.where((o) => completedStatuses.contains(o.status)).length,
      'canceled': orders.where((o) => o.status == 'CANCELLED').length,
    };
  });
});
