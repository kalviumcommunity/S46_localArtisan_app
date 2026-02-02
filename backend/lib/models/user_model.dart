import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { artisan, customer }

class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final UserRole role;
  final String? profileImageUrl;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      uid: id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      role: data['role'] == 'Artisan' ? UserRole.artisan : UserRole.customer,
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'role': role == UserRole.artisan ? 'Artisan' : 'Customer',
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
