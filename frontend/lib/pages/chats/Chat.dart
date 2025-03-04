import 'package:flutter/material.dart';
import 'package:pawsome/pages/chatbot/AiBot.dart';
import 'package:pawsome/pages/community/Adopt.dart';
import 'package:pawsome/pages/home/home.dart';
import 'DM.dart'; // Import the DM.dart file

// Stateful widget for the chat screen
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // Sample chat data with user details
  List<Map<String, String>> chatData = [
    {"name": "Ron", "time": "14.23 PM", "messages": "2", "avatar": "assets/images/avatar5.png"},
    {"name": "Cho", "time": "12.30 PM", "messages": "8", "avatar": "assets/images/avatar2.jpg"},
    {"name": "Cedric", "time": "11.00 AM", "messages": "", "avatar": "assets/images/avatar4.png"},
    {"name": "Emma", "time": "10.58 AM", "messages": "", "avatar": "assets/images/avatar1.jpg"},
    {"name": "Harry", "time": "01.25 AM", "messages": "4", "avatar": "assets/images/avatar3.png"},
  ];

  bool _isSearching = false;  // Flag to track search state
  final TextEditingController _searchController = TextEditingController();  // Controller for search input

  // Function to dynamically add a new chat
  void addChat(String name, String time, String messages, String avatar) {
    setState(() {
      chatData.add({
        "name": name,
        "time": time,
        "messages": messages,
        "avatar": avatar,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      appBar: AppBar(
        backgroundColor: Colors.amber[100], // Light yellow background color
        elevation: 0, // No shadow
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search chats...",  // Placeholder text for search
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 18),
        )
            : Padding(
          padding: const EdgeInsets.only(left: 20), // Adjust left padding
          child: const Text(
            "Chats",  // Screen title
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
                _isSearching = !_isSearching; // Toggle search state
                if (!_isSearching) _searchController.clear(); // Clear search input
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {}, // Placeholder for settings functionality
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatData.length, // Number of chat items
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to DM.dart when a chat is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DM(
                    userName: chatData[index]["name"]!,
                    profilePic: chatData[index]["avatar"]!,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber[50],  // Chat item background color
                borderRadius: BorderRadius.circular(10),  // Rounded corners
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(chatData[index]["avatar"]!), // Load user profile image
                  radius: 25,
                ),
                title: Text(
                  chatData[index]["name"]!, // Display user name
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(chatData[index]["time"]!), // Display last message time
                trailing: chatData[index]["messages"]!.isNotEmpty
                    ? CircleAvatar(
                  backgroundColor: Colors.green,  // Unread messages indicator
                  child: Text(
                    chatData[index]["messages"]!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
                    : const SizedBox(), // Empty space if no unread messages
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1), // Index for current page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adds a new chat when floating action button is pressed
          addChat("New User", "03.45 PM", "5", "assets/images/avatar3.png");
        },
        child: const Icon(Icons.add, color: Colors.black), // Black plus sign icon
        backgroundColor: Colors.amber[700], // Amber background color
      ),
    );
  }
}

// Custom Bottom Navigation Bar Widget for easier navigation
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // Index to track selected tab

  const CustomBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Sets active tab
      selectedItemColor: Colors.orange, // Active tab color
      unselectedItemColor: Colors.grey,  // Inactive tab color
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed, // Ensures even spacing between tabs
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ""),
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
