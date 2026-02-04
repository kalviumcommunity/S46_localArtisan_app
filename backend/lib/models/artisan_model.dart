import 'package:cloud_firestore/cloud_firestore.dart';

class Artisan {
  final String uid;
  final String shopName;
  final String shopDescription;
  final double rating;
  final int totalSales;
  final int storeViews;
  final DateTime createdAt;

  Artisan({
    required this.uid,
    required this.shopName,
    required this.shopDescription,
    this.rating = 0.0,
    this.totalSales = 0,
    this.storeViews = 0,
    required this.createdAt,
  });

  factory Artisan.fromMap(Map<String, dynamic> data, String id) {
    return Artisan(
      uid: id,
      shopName: data['shopName'] ?? '',
      shopDescription: data['shopDescription'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalSales: data['totalSales'] ?? 0,
      storeViews: data['storeViews'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'shopDescription': shopDescription,
      'rating': rating,
      'totalSales': totalSales,
      'storeViews': storeViews,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
