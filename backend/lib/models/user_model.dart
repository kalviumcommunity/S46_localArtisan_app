import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { artisan, customer }

class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final UserRole role;
  final String? profileImageUrl;
  final DateTime createdAt;
  final Map<String, bool> notificationSettings;
  final Map<String, bool> privacySettings;

  AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    this.notificationSettings = const {
      'orderUpdates': true,
      'promotions': false,
      'newMessages': true,
    },
    this.privacySettings = const {
      'showProfile': true,
      'shareAnalytics': true,
    },
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      uid: id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'],
      role: data['role'] == 'Artisan' ? UserRole.artisan : UserRole.customer,
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      notificationSettings: Map<String, bool>.from(data['notificationSettings'] ?? {}),
      privacySettings: Map<String, bool>.from(data['privacySettings'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role == UserRole.artisan ? 'Artisan' : 'Customer',
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'notificationSettings': notificationSettings,
      'privacySettings': privacySettings,
    };
  }

  AppUser copyWith({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    Map<String, bool>? notificationSettings,
    Map<String, bool>? privacySettings,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }
}
