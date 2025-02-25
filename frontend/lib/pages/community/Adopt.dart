import 'package:flutter/material.dart';
import 'Locate.dart';
import 'Sitter.dart';
import '../../reusable_widgets/CommunityWidgets.dart';

class Adopt extends StatefulWidget {
  const Adopt({super.key});

  @override
  _AdoptState createState() => _AdoptState();
}

class _AdoptState extends State<Adopt> {
  List<bool> likedStates = [false, false]; // Keep track of liked status for each pet card

  void _showCommentBox(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: "Write a comment...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close without posting
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String comment = commentController.text.trim();
                if (comment.isNotEmpty) {
                  // Handle comment submission
                  Navigator.pop(context); // Close the box after posting
                }
              },
              child: const Text("Post"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar("Community"),
      body: Column(
        children: [
          buildSearchBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFeatureButton("Adopt", Colors.orange, Colors.white, () {}),
              buildFeatureButton("Locate", Colors.grey, Colors.black, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Locate()));
              }),
              buildFeatureButton("Sitter", Colors.grey, Colors.black, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Sitter()));
              }),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                buildPetCard(
                  "Adorable 6-month street kitten vaccinated and dewormed",
                  "assets/kitten.jpg",
                  likedStates[0],
                      () {
                    setState(() {
                      likedStates[0] = !likedStates[0];
                    });
                  },
                ),
                buildPetCard(
                  "Adorable 6-month puppy vaccinated and dewormed",
                  "assets/puppy.jpg",
                  likedStates[1],
                      () {
                    setState(() {
                      likedStates[1] = !likedStates[1];
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildPetCard("New Post", "assets/kitten.jpg", false, () {}); // Placeholder
        },
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber[700],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  Widget buildPetCard(String description, String imagePath, bool isLiked, VoidCallback onLikePressed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.asset(imagePath, fit: BoxFit.cover, height: 150, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : null),
                onPressed: onLikePressed,
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => _showCommentBox(context), // Opens comment input
              ),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
