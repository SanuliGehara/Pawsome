import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/Adopt.dart';
import 'package:pawsome/pages/community/Locate.dart';
import 'package:pawsome/reusable_widgets/CommunityWidgets.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:pawsome/services/database_service.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0CC), // Light yellow background
        elevation: 0,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Image Placeholder
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

            // Description Field
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

            // Location Field
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
            // Post Button
            firebaseUIButton(context, 'POST', () {
              // Add Post logic (to be implemented later with firebase)
              _databaseService.createLocatePost();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Locate()));  // SHOULD NAVIGATE TO Adopt OR Locate PAGE
            }),
          ],
        ),
      ),
      bottomNavigationBar:buildBottomNavigationBar(context, 3),
    );
  }
}
