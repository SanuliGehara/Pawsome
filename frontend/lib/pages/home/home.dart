import 'package:flutter/material.dart';
//import 'search.dart';
//import 'chatbot.dart';

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

    // if (index == 2) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => Aibot()),
    //   );
    // }
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

    );
  }
}
