import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';



class EditProfilePage extends StatefulWidget {
  final String username;
  final String bio;
  final String profilePicture;
  final Function(String, String, String) onSave;

  const EditProfilePage({
    super.key,
    required this.username,
    required this.bio,
    required this.profilePicture,
    required this.onSave,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String updatedProfilePicture = "";
  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _bioController = TextEditingController(text: widget.bio);
    updatedProfilePicture = widget.profilePicture;
  }

  

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() async{


    String userId = FirebaseAuth.instance.currentUser?.uid??"s1tJsaeEjKSHPNnq5efT";


    widget.onSave(
      _usernameController.text,
      _bioController.text,
      updatedProfilePicture,
    );
    //updating user details
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': _usernameController.text,
      'description': _bioController.text,
      'profilePicture': updatedProfilePicture,
    });

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid??"s1tJsaeEjKSHPNnq5efT";
      String fileName = "profile_pictures/profile_$userId.jpg";
      Reference ref = FirebaseStorage.instance.ref().child(fileName);

      // Upload image and get URL
      String downloadUrl = await (await ref.putFile(File(image.path))).ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': downloadUrl,
      });

      setState(() => updatedProfilePicture = downloadUrl);
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: (updatedProfilePicture.isNotEmpty
                      ? NetworkImage(updatedProfilePicture)  // Show updated profile picture
                      : (widget.profilePicture.isNotEmpty
                      ? NetworkImage(widget.profilePicture)  // Show old profile picture from Firestore
                      : const AssetImage("assets/images/no_profile_pic.png") // Default asset image
                  )
                  ) as ImageProvider,
                ),
                Positioned(
                  right: -4,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: "Bio"),
              maxLength: 150,

            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
