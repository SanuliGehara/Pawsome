import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/accounts/own_profile.dart';
import 'package:pawsome/pages/accounts/pet_sitter/pet_sitter_profile_owner.dart';
import '../chatbot/AiBot.dart';
import '../community/Adopt.dart';
import '../home/home.dart';
import 'DM.dart';

/// Chat page widget that displays a list of chat previews
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  /// Tracks whether the search bar is active
  bool _isSearching = false;

  /// Controller for search input
  final TextEditingController _searchController = TextEditingController();

  /// Index for bottom navigation selection
  int _selectedIndex = 0;

  /// Handles bottom navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      /// Handle navigation based on index
      if (index == 0) {
        /// Currently stay on chat page
      } else if (index == 1) {
        /// Placeholder for potential navigation
        // Navigate to another page (e.g., Friends, Profile, etc.)
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SomeOtherPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: _isSearching
            /// If in search mode, show TextField
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search chats...",
            hintStyle: TextStyle(
              color: Theme.of(context).hintColor,
            ),
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        )
            /// Otherwise show static title
            : Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Chats",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold,),
          ),
        ),
        actions: [
          /// Toggles search mode on/off
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Theme.of(context).iconTheme.color,),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                /// Clear search on cancel
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
        ],
      ),

      /// Stream to listen for real-time chat updates
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var chatDocs = snapshot.data!.docs;

          /// Build list of chat tiles
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
                  /// Reset unread message count when chat is opened
                  FirebaseFirestore.instance.collection('chats').doc(chat.id).update({
                    "unreadCount": 0,
                  });

                  /// Navigate to direct message (DM) screen
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
                    color: isDark ? Colors.grey[850] : Colors.amber[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(avatar),
                      radius: 25,
                    ),
                    title: Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(lastMessage, style: Theme.of(context).textTheme.bodyMedium,),
                    trailing: unreadMessages > 0
                        /// Show unread message count if available
                        ? CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        unreadMessages.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                        /// Empty widget if no unread messages
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


/// A reusable custom bottom navigation bar used for app-wide navigation
class CustomBottomNavBar extends StatelessWidget {

  /// Index of the selected tab
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      /// Highlights the active tab
      currentIndex: currentIndex,

      /// Active tab color
      selectedItemColor: Colors.orange,

      /// Inactive tab color
      unselectedItemColor: Colors.grey,

      /// Shows labels of all items
      showUnselectedLabels: true,

      /// type: BottomNavigationBarType.fixed, // Ensures even spacing between tabs
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: ""),
        BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
      onTap: (index) async {
        /// Navigates to respective pages based on selected index
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
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
          // Get the current user ID.
          String userId = FirebaseAuth.instance.currentUser?.uid ?? "CJcHnkxI1GZY04aAYTmy";

          // Fetch user data from Firestore.
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

          // Check user type (Pet Sitter or Normal User).
          String userType = userDoc['category']; // Assuming the field 'category' exists.

          // Navigate to the appropriate profile page based on user type.
          if (userType == 'pet sitter') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PetSitterProfileOwnerPage()));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        }
      },
    );
  }
}

