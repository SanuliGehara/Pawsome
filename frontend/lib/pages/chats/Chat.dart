import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'DM.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.amber[100],
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search chats...",
            border: InputBorder.none,
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 18),
        )
            : Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Chats",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: isDarkMode ? Colors.white : Colors.black,),
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
        stream: FirebaseFirestore.instance.collection('chats').orderBy('timestamp', descending: true).snapshots(),
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
                    color: isDarkMode ? Colors.grey[800] : Colors.amber[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(avatar),
                      radius: 25,
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        lastMessage,
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[300] : Colors.black, // Change last message color
                        ),
                    ),
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
