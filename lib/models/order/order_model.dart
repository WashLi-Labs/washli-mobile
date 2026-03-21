import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/cart_provider.dart';

class OrderModel {
  final String id;
  final String orderId;
  final String timeAgo;
  final String orderDescription;
  final String status;
  
  // New fields for Firestore (Customer Side)
  final String? userId;
  final String? shopName;
  final List<CartItem>? items;
  final double? subTotal;
  final double? deliveryFee;
  final double? total;
  final String? paymentMethod;
  final bool? isPickup;
  final String? address;
  final DateTime? createdAt;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.timeAgo,
    required this.orderDescription,
    required this.status,
    this.userId,
    this.shopName,
    this.items,
    this.subTotal,
    this.deliveryFee,
    this.total,
    this.paymentMethod,
    this.isPickup,
    this.address,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'timeAgo': timeAgo,
      'orderDescription': orderDescription,
      'status': status,
      'userId': userId,
      'shopName': shopName,
      'items': items?.map((item) => {
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
        'description': item.description,
        'imagePath': item.imagePath,
      }).toList(),
      'subTotal': subTotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'paymentMethod': paymentMethod,
      'isPickup': isPickup,
      'address': address,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      orderId: map['orderId'] ?? id,
      timeAgo: map['timeAgo'] ?? 'Just now',
      orderDescription: map['orderDescription'] ?? '',
      status: map['status'] ?? 'pending',
      userId: map['userId'],
      shopName: map['shopName'],
      items: (map['items'] as List<dynamic>?)?.map((item) => CartItem(
        title: item['title'] ?? '',
        price: (item['price'] as num?)?.toDouble() ?? 0.0,
        quantity: item['quantity'] ?? 1,
        description: item['description'] ?? '',
        imagePath: item['imagePath'] ?? '',
      )).toList(),
      subTotal: (map['subTotal'] as num?)?.toDouble(),
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble(),
      total: (map['total'] as num?)?.toDouble(),
      paymentMethod: map['paymentMethod'],
      isPickup: map['isPickup'],
      address: map['address'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  OrderModel copyWith({
    String? id,
    String? orderId,
    String? timeAgo,
    String? orderDescription,
    String? status,
    String? userId,
    String? shopName,
    List<CartItem>? items,
    double? subTotal,
    double? deliveryFee,
    double? total,
    String? paymentMethod,
    bool? isPickup,
    String? address,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      timeAgo: timeAgo ?? this.timeAgo,
      orderDescription: orderDescription ?? this.orderDescription,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      shopName: shopName ?? this.shopName,
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPickup: isPickup ?? this.isPickup,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CartItem {
  final String title;
  final double price;
  final int quantity;
  final String description;
  final String imagePath;

  CartItem({
    required this.title,
    required this.price,
    required this.quantity,
    required this.description,
    required this.imagePath,
  });
}
