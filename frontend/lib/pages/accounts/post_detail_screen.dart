import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String profileImage;

  const PostDetailPage({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Text(username, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Post Image
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 350, // Adjust this value as needed
            ),
          ),
          // Interaction Icons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black, size: 30),
                  onPressed: () {}, // To be implemented later
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined, color: Colors.black, size: 30),
                  onPressed: () {}, // To be implemented later
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black, size: 30),
                  onPressed: () {}, // To be implemented later
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.black, size: 30),
                  onPressed: () {}, // To be implemented later
                ),
              ],
            ),
          ),
          // Sample Comment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: "sample_user ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "This is a sample comment."),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
