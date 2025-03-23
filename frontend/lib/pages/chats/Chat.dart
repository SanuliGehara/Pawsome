import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../chatbot/AiBot.dart';
import '../community/Adopt.dart';
import '../home/home.dart';
import 'DM.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on index
      if (index == 0) {
        // Stay on chat page
      } else if (index == 1) {
        // Navigate to another page (e.g., Friends, Profile, etc.)
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SomeOtherPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search chats...",
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 18),
        )
            : const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Chats",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chat = chatDocs[index];
              String userName = chat["userName"];
              String lastMessage = chat["lastMessage"] ?? "No messages yet";
              String avatar = chat["avatar"] ?? "assets/images/default_avatar.png";
              int unreadMessages = chat["unreadCount"] ?? 0;

              return GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance.collection('chats').doc(chat.id).update({
                    "unreadCount": 0,
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DM(
                        userName: userName,
                        profilePic: avatar,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(avatar),
                      radius: 25,
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(lastMessage),
                    trailing: unreadMessages > 0
                        ? CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        unreadMessages.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                        : const SizedBox(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Custom Bottom Navigation Bar Widget for easier navigation
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // Index to track selected tab

  const CustomBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      // Sets active tab
      selectedItemColor: Colors.orange,
      // Active tab color
      unselectedItemColor: Colors.grey,
      // Inactive tab color
      showUnselectedLabels: true,
      // type: BottomNavigationBarType.fixed, // Ensures even spacing between tabs
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: ""),
        BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
      onTap: (index) {
        // Handles navigation to different pages based on index
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
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
      },
    );
  }
}

