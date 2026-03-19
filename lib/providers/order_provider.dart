import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderModel {
  final String id;
  final String orderId; // e.g., #ORD-1523
  final String timeAgo;
  final String orderDescription;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  
  OrderModel({
    required this.id,
    required this.orderId,
    required this.timeAgo,
    required this.orderDescription,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });
}

class OrderState {
  final List<OrderModel> activeOrders;
  final List<OrderModel> pastOrders;
  final bool isLoading;

  OrderState({
    this.activeOrders = const [],
    this.pastOrders = const [],
    this.isLoading = false,
  });

  OrderState copyWith({
    List<OrderModel>? activeOrders,
    List<OrderModel>? pastOrders,
    bool? isLoading,
  }) {
    return OrderState(
      activeOrders: activeOrders ?? this.activeOrders,
      pastOrders: pastOrders ?? this.pastOrders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() {
    // Initial demo data matching the hardcoded UI
    return OrderState(
      activeOrders: [
        OrderModel(
          id: '1',
          orderId: '#ORD-1523',
          timeAgo: '2 minutes ago',
          orderDescription: 'Order ID - ORD1523 - RS.3500.00',
          status: 'Pending',
          totalAmount: 3500.00,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        OrderModel(
          id: '2',
          orderId: '#ORD-1523',
          timeAgo: '10 minutes ago',
          orderDescription: 'Order ID - ORD1523 - RS.3500.00',
          status: 'Pending',
          totalAmount: 3500.00,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        OrderModel(
          id: '3',
          orderId: '#ORD-1523',
          timeAgo: '2 minutes ago',
          orderDescription: 'Order ID - ORD1523 - RS.3500.00',
          status: 'In Progress',
          totalAmount: 3500.00,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ],
      pastOrders: [
        OrderModel(
          id: '4',
          orderId: '#ORD-1523',
          timeAgo: '2 minutes ago',
          orderDescription: 'Order ID - ORD1523 - RS.3500.00',
          status: 'Completed',
          totalAmount: 3500.00,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ],
    );
  }

  void addOrder(OrderModel order) {
    state = state.copyWith(
      activeOrders: [...state.activeOrders, order],
    );
  }

  void updateOrderStatus(String id, String newStatus) {
    bool foundInActive = false;
    
    final updatedActive = state.activeOrders.map((o) {
      if (o.id == id) {
        foundInActive = true;
        return OrderModel(
          id: o.id,
          orderId: o.orderId,
          timeAgo: o.timeAgo,
          orderDescription: o.orderDescription,
          status: newStatus,
          totalAmount: o.totalAmount,
          createdAt: o.createdAt,
        );
      }
      return o;
    }).toList();
    
    if (foundInActive) {
      state = state.copyWith(activeOrders: updatedActive);
      
      // If status is Completed or Canceled, move to past orders
      if (newStatus == 'Completed' || newStatus == 'Canceled') {
        moveToPast(id);
      }
    } else {
      // Check in past orders if needed, but usually we don't update past orders status except maybe for undo
      final updatedPast = state.pastOrders.map((o) {
        if (o.id == id) {
          return OrderModel(
            id: o.id,
            orderId: o.orderId,
            timeAgo: o.timeAgo,
            orderDescription: o.orderDescription,
            status: newStatus,
            totalAmount: o.totalAmount,
            createdAt: o.createdAt,
          );
        }
        return o;
      }).toList();
      state = state.copyWith(pastOrders: updatedPast);
    }
  }
  
  void moveToPast(String id) {
    try {
      final order = state.activeOrders.firstWhere((o) => o.id == id);
      state = state.copyWith(
        activeOrders: state.activeOrders.where((o) => o.id != id).toList(),
        pastOrders: [...state.pastOrders, order],
      );
    } catch (_) {
      // Order not in active orders
    }
  }
}

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(() {
  return OrderNotifier();
});
