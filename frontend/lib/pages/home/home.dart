import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/chatbot/AiBot.dart';
import 'package:pawsome/pages/chats/Chat.dart';
import 'package:pawsome/pages/community/Adopt.dart';
import 'package:pawsome/pages/settings/Setting.dart';
import '../accounts/own_profile.dart';
import '../accounts/pet_sitter/pet_sitter_profile.dart';
import '../accounts/pet_sitter/pet_sitter_profile_owner.dart';
import 'search.dart';
//import 'chatbot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0; // Tracks the selected icon index

  // Function to handle icon selection
  Future<void> _onIconTapped(int index) async {
    setState(() {
      _selectedIndex = index; // Updates the selected index
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Chat()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AiBot()),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Adopt()),
      );
    }
    if (index == 4) {
      // Get the current user
      String userId = FirebaseAuth.instance.currentUser?.uid??"CJcHnkxI1GZY04aAYTmy";

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // Check user type (Pet Sitter or Normal User)
      String userType = userDoc['category']; // Assuming 'userType' field exists

      // Navigate to the appropriate profile page based on userType
      if (userType == 'pet sitter') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetSitterProfileOwnerPage()), // Navigate to pet sitter profile
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to normal user profile
        );
      }
    }
  }

  List<String> profileImages = [
    "assets/images/s1.jpg",
    "assets/images/s2.jpg",
    "assets/images/s3.jpg",
    "assets/images/s4.jpg",
    "assets/images/s5.jpg",
    "assets/images/s6.jpg",
    "assets/images/s7.jpg",
    "assets/images/s8.jpg",
  ];

  List<String> posts = [
    "assets/images/p1.jpg",
    "assets/images/p2.png",
    "assets/images/p3.jpg",
    "assets/images/p4.jpg",
    "assets/images/p5.png",
    "assets/images/p6.jpg",
    "assets/images/p7.jpg",
    "assets/images/p8.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          // Shift icons slightly to the right
          child: Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(0), // Home
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.orange : Colors.grey,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(1), // Chat
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: _selectedIndex == 1 ? Colors.orange : Colors.grey,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(2), // Bot
                icon: Icon(
                  Icons.smart_toy_outlined,
                  color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(3), // Community
                icon: Icon(
                  Icons.group,
                  color: _selectedIndex == 3 ? Colors.orange : Colors.grey,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(4), // Profile
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 4 ? Colors.orange : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.white70, // Sets the app bar color
        title: Row(
          children: [
            Text(
              "Pawsome",
              style: TextStyle(
                color: Colors.deepOrange, // Sets the font color
                fontWeight: FontWeight.bold, // Makes the text bold
                fontSize: 34, // Sets the font size
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              ); // Navigates to the Search page
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Story bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  7,
                      (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    // Adds margin around each avatar
                    child: CircleAvatar(
                      radius: 30, // Makes the circle avatar bigger
                      backgroundImage: AssetImage(profileImages[index]),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Column(
              children: List.generate(
                  8,
                      (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Post
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 15, // Makes the circle avatar bigger
                              backgroundImage:
                              AssetImage(profileImages[index]),
                            ),
                          ),
                          Text("Profile Name"),
                          Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_vert)),
                        ],
                      ),
                      //Image Posts
                      Image.asset(posts[index]),
                      // image footer
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.message_outlined)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.ios_share_outlined)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(text: "Liked by "),
                                  TextSpan(
                                      text: "Profile Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "  and Others "),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}