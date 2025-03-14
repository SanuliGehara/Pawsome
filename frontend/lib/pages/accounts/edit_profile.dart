import 'package:flutter/material.dart';

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

  void _saveProfile() {
    widget.onSave(
      _usernameController.text,
      _bioController.text,
      updatedProfilePicture,
    );
    Navigator.pop(context);
  }

  void _changeProfilePicture() {
    // TODO: Implement image picker functionality to select a new profile picture
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _changeProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(updatedProfilePicture),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: "Bio"),
              maxLines: 3,
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
