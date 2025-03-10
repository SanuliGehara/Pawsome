import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  //method to create a new document(new post) to locate post collection
  Future createLocatePost() async {
    try {
       await _firestore.collection('locate_posts').add({"name":"helani lavanya", "email":"helani@gmail.com", "description": "I am a trained pet sitter with 8 years of experience. Feel free to reach out to me for your pet sitting", "likes": 60});
    }
    catch(error) {
      log(error.toString());
    }
        
  }
  
}