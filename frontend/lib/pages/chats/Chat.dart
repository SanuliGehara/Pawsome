import 'package:flutter/material.dart';
import 'DM.dart'; // Import the DM.dart file

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, String>> chatData = [
    {"name": "Ron", "time": "14.23 PM", "messages": "2", "avatar": "assets/avatar5.png"},
    {"name": "Cho", "time": "12.30 PM", "messages": "8", "avatar": "assets/avatar2.jpg"},
    {"name": "Cedric", "time": "11.00 AM", "messages": "", "avatar": "assets/avatar4.png"},
    {"name": "Emma", "time": "10.58 AM", "messages": "", "avatar": "assets/avatar1.jpg"},
    {"name": "Harry", "time": "01.25 AM", "messages": "4", "avatar": "assets/avatar3.png"},
  ];

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Function to add a new chat dynamically
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
      backgroundColor: Colors.grey[200], // Light background
      appBar: AppBar(
        backgroundColor: Colors.amber[100], // Light yellow background
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
            : Padding(
          padding: const EdgeInsets.only(left: 20), // Adjust indentation as needed
          child: const Text(
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
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatData.length,
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
                color: Colors.amber[50], // Chat background
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(chatData[index]["avatar"]!), // ✅ Loads local profile image
                  radius: 25,
                ),
                title: Text(
                  chatData[index]["name"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(chatData[index]["time"]!),
                trailing: chatData[index]["messages"]!.isNotEmpty
                    ? CircleAvatar(
                  backgroundColor: Colors.green,
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
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1), // Custom bottom nav bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addChat("New User", "03.45 PM", "5", "assets/avatar3.png");
        },
        child: const Icon(Icons.add, color: Colors.black), // ✅ Black color for the plus sign
        backgroundColor: Colors.amber[700],
      ),
    );
  }
}

// Separate Bottom Navigation Bar Widget for reuse
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed, // Ensures even spacing
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ""),
      ],
      onTap: (index) {
        if (index == 3) {
          Navigator.pushNamed(context, "/adopt");
        }
      },
    );
  }
}
