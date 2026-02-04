import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String artisanId;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stockQuantity;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.artisanId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      artisanId: data['artisanId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      stockQuantity: data['stockQuantity'] ?? 0,
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artisanId': artisanId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
