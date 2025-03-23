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
import 'package:pawsome/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks the selected icon index

  // Instance of DatabaseService to fetch posts.
  final DatabaseService _databaseService = DatabaseService();

  /// Function to handle icon selection.
  Future<void> _onIconTapped(int index) async {
    setState(() {
      _selectedIndex = index; // Update the selected index.
    });

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
    }
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AiBot()));
    }
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Adopt()));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          // Shift icons slightly to the right.
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(0), // Home
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.orange : Colors.grey,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(1), // Chat
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: _selectedIndex == 1 ? Colors.orange : Colors.grey,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(2), // Bot
                icon: Icon(
                  Icons.smart_toy_outlined,
                  color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _onIconTapped(3), // Community
                icon: Icon(
                  Icons.group,
                  color: _selectedIndex == 3 ? Colors.orange : Colors.grey,
                ),
              ),
              const Spacer(),
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
        backgroundColor: Colors.white70, // App bar color.
        title: Row(
          children: const [
            Text(
              "Pawsome",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Story bar.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  7,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: const CircleAvatar(
                      radius: 30,
                      // For demonstration, a placeholder image is used.
                      backgroundImage: AssetImage( "assets/images/s2.jpg"),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            // Posts section: Display only "normal" posts from the database.
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _databaseService.getPostsByType("Normal"),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final postsData = snapshot.data!;
                if (postsData.isEmpty) {
                  return const Center(child: Text("No posts available."));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: postsData.length,
                  itemBuilder: (context, index) {
                    final post = postsData[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post Header: Displays a placeholder avatar and username.
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                radius: 15,
                                // Check for a profile picture; if not present, use a default asset.
                                backgroundImage: (post["profilePicture"] != null &&
                                    (post["profilePicture"] as String).isNotEmpty)
                                    ? NetworkImage(post["profilePicture"])
                                    : const AssetImage( "assets/images/s1.jpg")
                                as ImageProvider,
                              ),
                            ),
                            // Display username if available.
                            Text(post["username"] ?? "Unknown User"),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                        // Post Image: If an image URL is provided, display the image.
                        post["imageUrl"] != null && (post["imageUrl"] as String).isNotEmpty
                            ? Image.network(post["imageUrl"])
                            : Container(),
                        // Post Footer: For actions like liking, commenting, and sharing.
                        Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.message_outlined)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share_outlined)),
                          ],
                        ),
                        // Post Description.
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Text(post["description"] ?? ""),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}