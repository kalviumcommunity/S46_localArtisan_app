import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/artisan_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const List<String> categories = [
    'Pottery & Ceramics',
    'Handwoven Textiles',
    'Wooden Craft',
    'Metal Works',
    'Jewelry & Ornaments',
    'Leather Goods',
    'Paintings & Wall Art',
    'Traditional Apparels',
    'Home & Living',
    'Garden & Outdoor',
    'Paper Crafts',
    'Natural Skincare',
  ];
  // --- User Profile ---
  Future<void> createUserProfile(AppUser user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // --- Artisan Profile ---
  Future<void> createArtisanProfile(Artisan artisan) async {
    try {
      await _db.collection('artisans').doc(artisan.uid).set(artisan.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<Artisan?> getArtisanProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('artisans').doc(uid).get();
      if (doc.exists) {
        return Artisan.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Stream<Artisan?> artisanStream(String uid) {
    return _db.collection('artisans').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return Artisan.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  // --- Products ---
  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add(product.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Product>> artisanProductsStream(String artisanId) {
    return _db
        .collection('products')
        .where('artisanId', isEqualTo: artisanId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Product>> allProductsStream() {
    return _db.collection('products').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList());
  }

  // --- Orders ---
  Future<void> placeOrder(OrderModel order) async {
    try {
      await _db.collection('orders').add(order.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> artisanOrdersStream(String artisanId) {
    return _db
        .collection('orders')
        .where('artisanId', isEqualTo: artisanId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<OrderModel>> customerOrdersStream(String customerId) {
    return _db
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<AppUser?> userProfileStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  Future<void> updateUserProfile(AppUser user) async {
    try {
      await _db.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // --- Addresses ---
  Future<void> addAddress(String userId, Address address) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .add(address.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Address>> userAddressesStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Address.fromMap(doc.data(), doc.id))
            .toList());
  }

  // --- Payment Methods (Metadata) ---
  Future<void> addPaymentMethod(String userId, Map<String, dynamic> paymentData) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('paymentMethods')
          .add(paymentData);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> userPaymentMethodsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('paymentMethods')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // --- Analytics ---
  Future<void> incrementStoreView(String artisanId) async {
    try {
      await _db.collection('artisans').doc(artisanId).update({
        'storeViews': FieldValue.increment(1),
      });
    } catch (e) {
      // Non-critical error
    }
  }

  Stream<double> getArtisanSalesStream(String artisanId) {
    return _db
        .collection('orders')
        .where('artisanId', isEqualTo: artisanId)
        .where('status', isEqualTo: 'delivered')
        .snapshots()
        .map((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['totalAmount'] ?? 0).toDouble();
      }
      return total;
    });
  }

  Stream<int> getActiveOrdersCountStream(String artisanId) {
    return _db
        .collection('orders')
        .where('artisanId', isEqualTo: artisanId)
        .snapshots()
        .map((snapshot) {
      // Filter out delivered and cancelled locally for simpler query (or add composite index)
      return snapshot.docs.where((doc) {
        final status = doc.data()['status'];
        return status != 'delivered' && status != 'cancelled';
      }).length;
    });
  }
}
