import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderModel {
  final String id;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  
  OrderModel({
    required this.id,
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
    return OrderState();
  }

  void addOrder(OrderModel order) {
    state = state.copyWith(
      activeOrders: [...state.activeOrders, order],
    );
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final updatedActive = state.activeOrders.map((o) {
      if (o.id == orderId) {
        return OrderModel(
          id: o.id,
          status: newStatus,
          totalAmount: o.totalAmount,
          createdAt: o.createdAt,
        );
      }
      return o;
    }).toList();
    
    state = state.copyWith(activeOrders: updatedActive);
  }
  
  void moveToPast(String orderId) {
    final order = state.activeOrders.firstWhere((o) => o.id == orderId);
    state = state.copyWith(
      activeOrders: state.activeOrders.where((o) => o.id != orderId).toList(),
      pastOrders: [...state.pastOrders, order],
    );
  }
}

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(() {
  return OrderNotifier();
});
