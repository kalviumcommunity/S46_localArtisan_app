import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String customerId;
  final String artisanId;
  final String productId;
  final String productName;
  final int quantity;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.artisanId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      customerId: data['customerId'] ?? '',
      artisanId: data['artisanId'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 1,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: _statusFromString(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'artisanId': artisanId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static OrderStatus _statusFromString(String? status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.pending,
    );
  }
}
