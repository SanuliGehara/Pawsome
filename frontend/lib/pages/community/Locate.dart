import 'package:flutter/material.dart';
import 'package:pawsome/services/database_service.dart';
import 'Adopt.dart';
import 'Sitter.dart';
import '../../reusable_widgets/CommunityWidgets.dart';

class Locate extends StatefulWidget {
  const Locate({super.key});

  @override
  _LocateState createState() => _LocateState();
}

class _LocateState extends State<Locate> {
  List<bool> likedStates = List.generate(2, (index) => false);
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String comment = commentController.text.trim();
                if (comment.isNotEmpty) {
                  Navigator.pop(context);
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
      appBar: buildAppBar("Locate Lost Pets"),
      body: Column(
        children: [
          buildSearchBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFeatureButton("Adopt", Colors.grey, Colors.black, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Adopt()));
              }),
              buildFeatureButton("Locate", Colors.orange, Colors.white, () {}),
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
                  "Lost Labrador Retriever near Downtown",
                  "assets/images/puppy.jpg",
                  likedStates[0],
                      () {
                    setState(() {
                      likedStates[0] = !likedStates[0];
                    });
                  },
                  context,
                ),
                buildPetCard(
                  "Missing Cat last seen at Park Avenue",
                  "assets/images/kitten.jpg",
                  likedStates[1],
                      () {
                    setState(() {
                      likedStates[1] = !likedStates[1];
                    });
                  },
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  Widget buildPetCard(String description, String imagePath, bool isLiked, VoidCallback onLikePressed, BuildContext context) {
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
              //IconButton(icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border), onPressed: onLikePressed),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => _showCommentBox(context),
              ),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
