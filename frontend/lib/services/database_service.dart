import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawsome/services/storage_service.dart';

class DatabaseService {
  // firestore database reference
  final _firestore = FirebaseFirestore.instance;

  /// Function to Create a user and save it in Firestore
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

  /// Function to Create a normal user and save it in Firestore
  Future createNormalUser(String username, String email) async{
    try {
      await _firestore.collection('users').add({
        "username":username,
        "email":email,
        "category":"normal",
        "bio":"Your Bio",
        "profilePicture":"",
        "savedPosts":[],
        "posts":[],
        "unreadCount":0,
        "lastMessage":"",
        "timeStamp":FieldValue.serverTimestamp(), // Store creation time
      });
    }
    catch (error) {
      log(error.toString());
    }
  }

  /// Function to Create a pet sitter user and save it in Firestore
  Future createPetSitterUser(String username, String email) async{
    try {
      await _firestore.collection('users').add({
        "username":username,
        "email":email,
        "category":"pet sitter",
        "description":"Your Description",
        "profilePicture":"",
        "likes":0,
        "rating":1,
      });
    }
    catch (error) {
      log(error.toString());
    }
  }

  /// Fetch pet sitters from Firestore
  Stream<List<Map<String, dynamic>>> getPetSitters() {
    return _firestore
        .collection('users')
        .where('category', isEqualTo: 'pet sitter') // Filter only pet sitters
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList());
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
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return []; // Return empty list instead of null
      }
      return snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "description": doc["description"] ?? "No description available",
          "imageUrl": doc["imageUrl"] ?? "",
          "postType": doc["postType"] ?? "Unknown",
        };
      }).toList();
    });
  }

  /// Fetch posts that belong only to the "Adopt" type
  Stream<List<Map<String, dynamic>>> getAdoptPosts() {
    return _firestore
        .collection('posts')
        .where('postType', isEqualTo: 'Adopt')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return []; // Return empty list instead of null
      }
      return snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "description": doc["description"] ?? "No description available",
          "imageUrl": doc["imageUrl"] ?? "",
          "postType": doc["postType"] ?? "Unknown",
        };
      }).toList();
    });
  }

  /// Update a post with any field and save changes in Firestore/ FireStorage
  Future<void> updatePost({
    required String postId,
    String? newDescription,
    String? newPostType,
    File? newImageFile,  // File if user uploads a new image
    String? oldImageUrl, // URL of the old image to delete if needed
  }) async {
    try {
      String? imageUrl = oldImageUrl; // Keep the old image URL by default

      // If the user selected a new image, upload it and delete the old one
      if (newImageFile != null) {
        // Upload new image
        String? uploadedImageUrl = await StorageService().uploadImage(newImageFile);

        if (uploadedImageUrl != null) {
          imageUrl = uploadedImageUrl; // Set new image URL
          if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
            await FirebaseStorage.instance.refFromURL(oldImageUrl).delete(); // Delete old image
          }
        }
      }

      // Update Firestore document
      await _firestore.collection('posts').doc(postId).update({
        if (newDescription != null) "description": newDescription,
        if (newPostType != null) "postType": newPostType,
        "imageUrl": imageUrl, // Update image URL if changed
        "timestamp": FieldValue.serverTimestamp(), // Update timestamp
      });
    } catch (error) {
      log("Error updating post: $error");
    }
  }


  /// Delete a post from FireStore
  Future<void> deletePost(String postId, String? imageUrl) async {
    try {
      // If there's an image, delete it from Firebase Storage
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // Delete the post document from Firestore
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      log("Error deleting post: $error");
    }
  }


  Future<void> savePost(String postId,bool isSaved) async {
    try {
      // Get current user ID
      String currentUserId = FirebaseAuth.instance.currentUser?.uid??"s1tJsaeEjKSHPNnq5efT";


      // Reference to user's document
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(currentUserId);

      //if post is aldready saved remove post id from the saved posts in user document
      if (isSaved) {
        await userDoc.update({
          'savedPosts': FieldValue.arrayRemove([postId])
        });
        //if post isnt saved add post id to the saved posts field in user document
      } else {
        await userDoc.update({
          'savedPosts': FieldValue.arrayUnion([postId])
        });
      }
    } catch (e) {
      print("Error saving post: $e");
    }
  }

}




