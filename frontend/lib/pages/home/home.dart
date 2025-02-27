import 'package:flutter/material.dart';
import 'search.dart';
import 'chatbot.dart';
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
  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index; // Updates the selected index
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Aibot()),
      );
    }
  }

  List<String> profileImages = [
    "images/s1.jpg",
    "images/s2.jpg",
    "images/s3.jpg",
    "images/s4.jpg",
    "images/s5.jpg",
    "images/s6.jpg",
    "images/s7.jpg",
    "images/s8.jpg",
  ];

  List<String> posts = [
    "images/p1.jpg",
    "images/p2.png",
    "images/p3.jpg",
    "images/p4.jpg",
    "images/p5.png",
    "images/p6.jpg",
    "images/p7.jpg",
    "images/p8.jpg"
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
              // Action for settings button
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