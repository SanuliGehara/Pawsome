import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawsome/reusable_widgets/CommunityWidgets.dart';

class PetSitterProfileOwnerPage extends StatefulWidget {
  const PetSitterProfileOwnerPage({super.key});

  @override
  _PetSitterProfileOwnerPageState createState() => _PetSitterProfileOwnerPageState();
}

class _PetSitterProfileOwnerPageState extends State<PetSitterProfileOwnerPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPasswordVisible = false;
  String _profileImageUrl = "assets/images/default_user.jfif"; // Default image
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load User Profile from Firestore
  void _loadUserProfile() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot userDoc = await _firestore.collection('pet_sitters').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        _usernameController.text = userDoc['username'] ?? '';
        _descriptionController.text = userDoc['description'] ?? '';
        _profileImageUrl = userDoc['profileImage'] ?? "assets/images/default_user.jfif";
      });
    }
  }

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Upload Image to Firebase Storage
  Future<String?> _uploadImage(File image) async {
    String userId = _auth.currentUser!.uid;
    Reference ref = FirebaseStorage.instance.ref().child("profile_pictures/$userId.jpg");

    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  // Update Profile in Firestore
  void _updateProfile() async {
    String userId = _auth.currentUser!.uid;
    String? imageUrl = _profileImageUrl;

    // Upload new image if selected
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    // Update Firestore
    await _firestore.collection('pet_sitters').doc(userId).update({
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(), // Hash password in real use!
      'description': _descriptionController.text.trim(),
      'profileImage': imageUrl,
    });

    setState(() {
      _profileImageUrl = imageUrl!;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated Successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0CC), // Light yellow
        elevation: 0,
        title: const Text(
          "Pet Sitter Profile",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"), // Paw print background
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        // Profile Image with Camera Icon
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.orange, width: 4),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!) as ImageProvider
                                    : (_profileImageUrl.startsWith("http")
                                    ? NetworkImage(_profileImageUrl)
                                    : AssetImage(_profileImageUrl)) as ImageProvider,
                              ),
                            ),
                            // Camera Icon
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Username Field
                        inputField("pet sitter name", _usernameController),
                        const SizedBox(height: 20),

                        // Password Field with Show/Hide
                        inputField("password", _passwordController, isPassword: true),
                        const SizedBox(height: 20),

                        // Description Box
                        inputField("I am an experienced pet sitter with 4 years of experience.", _descriptionController),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16), // ✅ Increased Padding
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _updateProfile,
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: buildBottomNavigationBar(context, 4),
    );
  }

  // Styled Input Field
  Widget inputField(String hint, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD9A5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            }),
          )
              : null,
        ),
      ),
    );
  }
}
