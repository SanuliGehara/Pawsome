import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // database reference
  final _firestore = FirebaseFirestore.instance;
  
  //method to create a new document(new post) to locate post collection
  createLocatePost() {
    try {
       _firestore.collection('locate_posts').add({"name":"helani lavanya", "email":"helani@gmail.com", "description": "I am a trained pet sitter with 8 years of experience. Feel free to reach out to me for your pet sitting", "likes": 60});
    }
    catch(error) {
      log(error.toString());
    }
        
  }
  
}