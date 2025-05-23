import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawsome/pages/community/new_post.dart';
import 'package:pawsome/services/database_service.dart';
import 'Adopt.dart';
import 'Sitter.dart';
import '../../reusable_widgets/community_widgets.dart';

/// Stateful widget to manage the Locate page
class Locate extends StatefulWidget {
  const Locate({super.key});

  @override
  _LocateState createState() => _LocateState();
}

class _LocateState extends State<Locate> {
  /// List to track the like state of pet posts, initialized with false (unliked)
  List<bool> likedStates = List.generate(2, (index) => false);
  /// List to track the save state of pet posts, initialized with false (unsaved)
  List<bool> savedStates = List.generate(2, (index) => false);

  /// Instance of DatabaseService for fetch posts.
  final DatabaseService _databaseService = DatabaseService();

  /// Function to show a comment dialog box for user input
  void _showCommentBox(BuildContext context) {
    TextEditingController commentController = TextEditingController();  // Controller to manage comment text input

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
                  Navigator.pop(context); // Close the dialog after submitting
                }
              },
              child: const Text("Post"),
            ),
          ],
        );
      },
    );
  }

  // Function to show the update post dialog
  void _showUpdateDialog(BuildContext context, String postId, String oldDescription, String oldPostType, String? oldImageUrl) {
    TextEditingController descController = TextEditingController(text: oldDescription);
    TextEditingController typeController = TextEditingController(text: oldPostType);
    File? newImageFile;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
              TextField(controller: typeController, decoration: InputDecoration(labelText: "Post Type")),
              ElevatedButton(
                child: Text("Change Image"),
                onPressed: () async {
                  // Use Image Picker to select a new image
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    newImageFile = File(pickedFile.path);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
            TextButton(
              child: Text("Update"),
              onPressed: () async {
                await _databaseService.updatePost(
                  postId: postId,
                  newDescription: descController.text.trim(),
                  newPostType: typeController.text.trim(),
                  newImageFile: newImageFile,
                  oldImageUrl: oldImageUrl,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Post updated successfully"), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        );
      },
    );
  }

  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
          fontSize: 26,
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.grey[200],
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
      appBar: buildAppBar("Locate Lost Pets"),  // Custom app bar with title
      body: Column(
        children: [
          buildSearchBar(), // Search bar widget for filtering results

          // Row containing feature buttons for navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button to navigate to the Adopt page
              buildFeatureButton("Adopt", Theme.of(context).cardColor, Theme.of(context).textTheme.bodyLarge!.color!, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Adopt()));
              }),
              // Current page button (Locate) highlighted in orange
              buildFeatureButton("Locate", Colors.orange, Colors.white, () {}),
              // Button to navigate to the Sitter page
              buildFeatureButton("Sitter", Theme.of(context).cardColor, Theme.of(context).textTheme.bodyLarge!.color!, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Sitter()));
              }),
            ],
          ),

          // Expanded widget to allow the ListView to take available screen space
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _databaseService.getLocatePosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Locate posts found"));
                }


                List<Map<String, dynamic>> posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return buildPetCard(
                      post["description"] ?? "No Description",
                      post["imageUrl"]?.isNotEmpty == true ? post["imageUrl"] : "assets/images/puppy.jpg",

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
                      context,  // Passing context for comment box
                      post["id"],
                      post["imageUrl"],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Floating action button to add new post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostPage()), // Creating new post for locate pes
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber[700],
      ),

      // Bottom navigation bar with highlighting on the Locate page (index 3)
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  // Function to build a pet card widget for displaying lost pet posts
  Widget buildPetCard(
      String description,
      String imagePath,
      bool isLiked,
      VoidCallback onLikePressed,
      bool isSaved,
      VoidCallback onSavePressed,
      BuildContext context,
      String postId, // Add postId
      String? imageUrl, // Add imageUrl
      ){
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10), // Adds spacing between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
      child: Column(
        children: [

          // Displaying the pet image with rounded top corners
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image not available'));
              },
            ),
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
                onPressed: () => _showCommentBox(context),
              ),

              // Save button to toggle between marked and unmarked states
              IconButton(
                icon: Icon( isSaved ? Icons.bookmark : Icons.bookmark_border, color : isSaved ? Colors.orange : null),
                onPressed: () async {
                  onSavePressed();
                  await _databaseService.savePost(postId, isSaved);

                },
              ),

              // Delete and Update Buttons
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showUpdateDialog(context, postId, description, "Locate", imageUrl),
              ),

              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _databaseService.deletePost(postId, imageUrl);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Post deleted successfully"), backgroundColor: Colors.orangeAccent),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
