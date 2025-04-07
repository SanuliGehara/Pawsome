import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pawsome/reusable_widgets/CommunityWidgets.dart';
import 'package:pawsome/services/database_service.dart';
import 'package:pawsome/services/storage_service.dart';
import '../../main.dart';

/// A stateful widget that allows users to create a new post.
/// Users can add a description, location, and optionally an image placeholder.
class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

/// State class for [NewPostPage].
/// Manages the user input for the new post and handles the post submission.
class _NewPostPageState extends State<NewPostPage> {
  // Store and upload image file to firebase storage
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String _postType = "Normal";

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  /// Function to pick an image from the gallery.
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  /// Function to create a new post
  Future<void> _createPost() async {
    if (_descriptionController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    String? imageUrl;
    if (_selectedImage != null) {
      // Upload image to Firebase Storage and get URL
      imageUrl = await _storageService.uploadImage(_selectedImage!);
    }

    // Save post to Firestore database
    await _databaseService.createPost(
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      imageUrl: imageUrl,
      postType: _postType,
    );

    // Show confirmation message to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, // Uses dynamic theme
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add New Post",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage == null
                    ? Center(child: Icon(Icons.camera_alt, size: 50, color: textColor))
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            // Post Description Field
            _buildTextField(_descriptionController, 'Add description', theme),
            const SizedBox(height: 20),

            // Post Location Field
            _buildTextField(_locationController, 'Add location', theme),
            const SizedBox(height: 20),

            // Post Type Field
            DropdownButtonFormField<String>(
              value: _postType,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: ["Locate", "Adopt", "Normal"].map((String type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _postType = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Post submit button
            ElevatedButton(
              onPressed: _createPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.orange[700] : Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'POST',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  // Reusable text field widget to use for two text fields (location, description)
  Widget _buildTextField(TextEditingController controller, String hint, ThemeData theme) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600]),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
