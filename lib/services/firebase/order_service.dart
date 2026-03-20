import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'washliauth',
  );

  Future<String> createOrder(OrderModel order) async {
    final docRef = _db.collection('orders').doc();
    final orderWithId = order.copyWith(
      id: docRef.id,
      orderId: order.orderId.isEmpty || order.orderId == 'Generating...' 
          ? '#ORD-${docRef.id.substring(0, 6).toUpperCase()}' 
          : order.orderId,
    );
    await docRef.set(orderWithId.toMap());
    return docRef.id;
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return _db.collection('orders').doc(orderId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return OrderModel.fromMap(snapshot.data()!, snapshot.id);
      }
      return null;
    });
  }
}
