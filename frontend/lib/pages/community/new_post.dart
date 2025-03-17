import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/Adopt.dart';
import 'package:pawsome/pages/community/Locate.dart';
import 'package:pawsome/pages/community/Sitter.dart';
import 'package:pawsome/reusable_widgets/CommunityWidgets.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:pawsome/services/database_service.dart';

/// A stateful widget that allows users to create a new post.
/// Users can add a description, location, and optionally an image placeholder.
class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}


/// State class for [NewPostPage].
/// Manages the user input for the new post and handles the post submission.
class _NewPostPageState extends State<NewPostPage> {
  // Controller for the description text field.
  final TextEditingController _descriptionController = TextEditingController();

  // Controller for the location text field.
  final TextEditingController _locationController = TextEditingController();

  // Instance of DatabaseService for handling post creation.
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0CC), // Light yellow background
        elevation: 0,

        // Back button to navigate to the previous screen.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // Main column that contains the post creation UI.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Image Placeholder for post.
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, size: 50, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),

            // Post Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Add description',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Post's Location Field
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Add location',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Button to submit the new post.
            firebaseUIButton(context, 'POST', () {
              // Placeholder for adding post logic with Firebase.
              _databaseService.createLocatePost();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Sitter()));  // SHOULD NAVIGATE TO Adopt OR Locate PAGE
            }),
          ],
        ),
      ),
      bottomNavigationBar:buildBottomNavigationBar(context, 3),
    );
  }
}
