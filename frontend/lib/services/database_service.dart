import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  // firestore database reference
  final _firestore = FirebaseFirestore.instance;

  // Create a user
  Future createUser(String username, String email, String category) async{
    try {
      await _firestore.collection('users').add({
        "name":username,
        "email":email,
        "category":category
      });
    }
    catch (error) {
      log(error.toString());
    }
  }

  /// Function to create a new post and save it in Firestore.
  Future<void> createPost({required String description, required String location, String? imageUrl, required String postType}) async {
    try {
      await _firestore.collection('posts').add({
        "description": description,
        "location": location,
        "imageUrl": imageUrl ?? "", // If no image, store an empty string
        "postType": postType, // Store post type
        "timestamp": FieldValue.serverTimestamp(), // Store creation time
      });
    } catch (error) {
      log("Error creating post: $error");
    }
  }

  /// Fetch posts from Firestore based on the type (normal/ Locate/ Adopt)
  Stream<List<Map<String, dynamic>>> getPostsByType(String postType) {
    return _firestore
        .collection('posts')
        .where('postType', isEqualTo: postType)
        .orderBy('timestamp', descending: true) // Order by latest posts
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList());
  }

  /// Fetch posts that belong only to the "Locate" type
  Stream<List<Map<String, dynamic>>> getLocatePosts() {
    return _firestore
        .collection('posts')
        .where('postType', isEqualTo: 'Locate')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
  
}