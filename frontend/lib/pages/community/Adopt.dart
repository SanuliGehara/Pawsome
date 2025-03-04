import 'package:flutter/material.dart';
import 'Locate.dart';
import 'Sitter.dart';
import '../../reusable_widgets/CommunityWidgets.dart';

// Stateful widget to manage the Adopt Page
class Adopt extends StatefulWidget {
  const Adopt({super.key});

  @override
  _AdoptState createState() => _AdoptState();
}

class _AdoptState extends State<Adopt> {
  // List to track the liked state of each pet post. Initially, both are set to false (unliked).
  List<bool> likedStates = [false, false];
  // List to track the save state of pet posts, initialized with false (unsaved)
  List<bool> savedStates = List.generate(2, (index) => false);

  // Function to display a comment input dialog box
  void _showCommentBox(BuildContext context) {
    TextEditingController commentController = TextEditingController();  // Controller to capture user input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: "Write a comment...", // Placeholder text inside the text field
            ),
          ),
          actions: [
            // Cancel button to close the dialog without saving
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            // Post button to submit the comment if it's not empty
            TextButton(
              onPressed: () {
                String comment = commentController.text.trim(); // Trimmed text to remove unwanted spaces
                if (comment.isNotEmpty) {
                  // Handle comment submission
                  Navigator.pop(context); // Close the dialog after posting
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
      backgroundColor: Colors.grey[200],  // Light grey background
      appBar: buildAppBar("Adopt Community"), // Custom app bar with title
      body: Column(
        children: [
          buildSearchBar(), // Search bar widget for filtering results

          // Row containing feature buttons for navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // // Current page button (Adopt) highlighted in orange
              buildFeatureButton("Adopt", Colors.orange, Colors.white, () {}),
              // Button to navigate to the Locate page
              buildFeatureButton("Locate", Colors.grey, Colors.black, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Locate()));
              }),
              // Button to navigate to the Sitter page
              buildFeatureButton("Sitter", Colors.grey, Colors.black, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Sitter()));
              }),
            ],
          ),

          // Expanded widget to allow the ListView to take available screen space
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8), // Padding for spacing
              children: [
                // Lost pet post 1: Labrador Retriever
                buildPetCard(
                  "Adorable 6-month street kitten vaccinated and dewormed", // Description text
                  "assets/images/kitten.jpg", // Image asset path
                  likedStates[0], // Whether the post is liked
                      () {
                    setState(() {
                      likedStates[0] = !likedStates[0]; // Toggle like state
                    });
                  },
                  savedStates[0],
                      () {
                    setState(() {
                      savedStates[0] = !savedStates[0]; // Toggle save state
                    });
                  },
                ),
                buildPetCard(
                  "Adorable 6-month puppy vaccinated and dewormed", // Description text
                  "assets/images/puppy.jpg",  // Image asset path
                  likedStates[1], // Whether the post is liked
                      () {
                    setState(() {
                      likedStates[1] = !likedStates[1]; // Toggle like state
                    });
                  },
                  savedStates[1],
                      () {
                    setState(() {
                      savedStates[1] = !savedStates[1]; // Toggle save state
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Floating action button to add a new pet adoption post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildPetCard("New Post", "assets/images/kitten.jpg", false, () {}, false, () {}); // Placeholder action
        },
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber[700], // Sets the button color to amber
      ),

      // Custom bottom navigation bar with highlighting on the "Adopt" tab (index 3)
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  // Function to build a pet card widget for displaying lost pet posts
  Widget buildPetCard(String description, String imagePath, bool isLiked, VoidCallback onLikePressed, bool isSaved, VoidCallback onSavePressed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10), // Adds spacing between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
      child: Column(
        children: [

          // Displaying the pet image with rounded top corners
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.asset(imagePath, fit: BoxFit.cover, height: 150, width: double.infinity),
          ),

          // Pet description text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, textAlign: TextAlign.center),
          ),

          // Row for action buttons (Like, Comment, Save)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              // Like button to toggle between liked and unliked states
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : null),
                onPressed: onLikePressed,
              ),

              // Comment button to open the comment box
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => _showCommentBox(context), // Opens comment input
              ),

              // Save button to toggle between marked and unmarked states
              IconButton(
                icon: Icon( isSaved ? Icons.bookmark : Icons.bookmark_border, color : isSaved ? Colors.black : null),
                onPressed : onSavePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
