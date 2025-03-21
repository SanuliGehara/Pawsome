import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../accounts/others_profile.dart';
import '../accounts/pet_sitter/pet_sitter_profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _fetchUsers() {
    return _firestore.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                query = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: "Search profiles...",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs.map((doc) {
            return {
              'userId': doc.id,
              'username': doc['username'],
              'image': doc['profilePicture'] ?? "assets/images/no_profile_pic.png",
              'category': doc['category']
            };
          }).toList();

          var filteredUsers = users.where((user) {
            return user['username'].toLowerCase().contains(query);
          }).toList();

          return filteredUsers.isEmpty
              ? Center(child: Text("No users found", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    String category = filteredUsers[index]['category'];
                    // Navigate to ProfilePage with the Firestore user ID
                    if (category == 'normal') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(
                                  userId: filteredUsers[index]['userId']),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PetSitterProfilePage(
                                  userId: filteredUsers[index]['userId']), // Navigate to Pet Sitter Profile
                        ),
                      );
                    }
                  },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(filteredUsers[index]['image']),
                        ),
                        SizedBox(width: 10),
                        Text(
                          filteredUsers[index]['username'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
              );
            },
          );
        },
      ),
    );
  }
}
