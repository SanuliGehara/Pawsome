import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service class to handle Firebase Storage operations.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an image to Firebase Storage and returns the image URL.
  Future<String?> uploadImage(File imageFile) async {
    try {
      String filePath = 'post_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (error) {
      return null;
    }
  }
}
