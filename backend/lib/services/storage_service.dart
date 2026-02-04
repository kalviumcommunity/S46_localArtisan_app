import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProductImage({
    required String artisanId,
    required File imageFile,
    required String productName,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${productName.replaceAll(' ', '_')}.jpg';
      final path = 'products/$artisanId/$fileName';
      
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(imageFile);
      
      if (uploadTask.state == TaskState.success) {
        return await ref.getDownloadURL();
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Rethrow to allow UI to catch the specific error
    }
  }

  Future<void> deleteProductImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
