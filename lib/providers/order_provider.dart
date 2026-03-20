import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../services/firebase/order_service.dart';

// Export the model so merchant widgets can find it without extra imports
export '../models/order_model.dart';

// NEW PROVIDERS FOR CUSTOMER
final orderService = Provider((ref) => OrderService());

final orderStreamProvider = StreamProvider.family<OrderModel?, String>((ref, orderId) {
  final service = ref.watch(orderService);
  return service.streamOrder(orderId);
});

// LEGACY PROVIDERS FOR MERCHANT
class OrderState {
  final List<OrderModel> activeOrders;
  final List<OrderModel> pastOrders;

  OrderState({
    this.activeOrders = const [],
    this.pastOrders = const [],
  });

  OrderState copyWith({
    List<OrderModel>? activeOrders,
    List<OrderModel>? pastOrders,
  }) {
    return OrderState(
      activeOrders: activeOrders ?? this.activeOrders,
      pastOrders: pastOrders ?? this.pastOrders,
    );
  }
}

/// Refactored to use the Notifier pattern (Riverpod 2.0+) as per project standards.
class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() {
    return OrderState(
      activeOrders: [
        OrderModel(
          id: '1',
          orderId: '#ORD-001',
          timeAgo: '2 mins ago',
          orderDescription: 'Laundry - Wash & Fold (5kg)',
          status: 'Pending',
        ),
        OrderModel(
          id: '2',
          orderId: '#ORD-002',
          timeAgo: '15 mins ago',
          orderDescription: 'Dry Cleaning - Suit (2)',
          status: 'In Progress',
        ),
      ],
      pastOrders: [
        OrderModel(
          id: '3',
          orderId: '#ORD-003',
          timeAgo: 'Yesterday',
          orderDescription: 'Laundry - Wash (3kg)',
          status: 'Completed',
        ),
      ],
    );
  }

  void updateOrderStatus(String orderId, String status) {
    final updatedActive = state.activeOrders.map((o) {
      if (o.id == orderId) {
        return o.copyWith(status: status);
      }
      return o;
    }).toList();
    
    state = state.copyWith(activeOrders: updatedActive);
  }
}

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(() {
  return OrderNotifier();
});
