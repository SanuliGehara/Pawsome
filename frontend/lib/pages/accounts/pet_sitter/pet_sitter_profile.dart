import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/chats/Chat.dart';
import 'package:pawsome/reusable_widgets/community_widgets.dart';

import '../../chats/DM.dart';

/// A stateful widget representing the pet sitter's profile page.
/// This page displays the pet sitter's profile picture, name, description,
/// rating system, and provides options for liking the profile and starting a chat.
class PetSitterProfilePage extends StatefulWidget {
  final String userId;

  const PetSitterProfilePage({super.key,required this.userId});

  @override
  _PetSitterProfilePageState createState() => _PetSitterProfilePageState();
}

/// State class for [PetSitterProfilePage].
/// Manages UI state such as the like count and the rating, and handles interactions.
class _PetSitterProfilePageState extends State<PetSitterProfilePage> {
  String name = "";
  String description = "";
  String profilePicture = "";
  String email = "";
  int likes = 0;
  double rating = 0;

  @override
  void initState() {
    super.initState();
    fetchPetSitterData();
  }


  Future<void> fetchPetSitterData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        setState(() {
          name = doc['username'];
          description = doc['description'];
          profilePicture = doc['profilePicture'];
          email = doc['email'];
          likes = doc['likes'];
          rating = doc['rating'].toDouble();
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFFF0CC), // Light yellow
        elevation: 0,

        // Back button to navigate to the previous screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          // Full-Screen Background Image with Reduced Opacity
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop), // ✅ Reduced Opacity
              child: Image.asset(
                "assets/images/background.png", // Paw print background
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content area wrapped in a scrollable column
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Profile Image with an interactive orange-bordered circle.
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.orange, width: 4),
                          ),

                          // Tapping the image opens a dialog to view it in full size.
                          child: InkWell(
                            onTap: showProfilePicture,
                            child:  CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: profilePicture.startsWith("http")
                                  ? NetworkImage(profilePicture)
                                  : AssetImage("assets/images/no_profile_pic.png") as ImageProvider, // Profile Picture
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Custom input field for the pet sitter's name
                        inputField(name),
                        const SizedBox(height: 25),

                        // Description container
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD9A5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Star Rating System
                        starRating(),
                        const SizedBox(height: 25),

                        // Likes & Chat Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconButton(Icons.favorite_border, "$likes Likes", () async {
                              setState(() {
                                likes++; // Increment likes on tap
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userId)
                                  .update({'likes': likes});
                            }),

                            const SizedBox(width: 40),

                            // Chat icon to navigate to chat page
                            iconButton(Icons.chat_bubble_outline, "Chat", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DM(
                                userName: name, // Pass the profile user's name
                                profilePic: profilePicture, // Pass the profile picture URL
                              ),
                              )
                              );
                            }),
                          ],
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

      // Bottom Navigation Bar from reusable widgets
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  /// Returns a styled input field widget with a centered text field.
  /// [hint] provides the placeholder text
  Widget inputField(String hint) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD9A5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  /// Creates a row of star icons for the rating system.
  /// Tapping a star sets the rating dynamically.
  Widget starRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              rating = index + 1.0; // Update the rating based on the star tapped
            });
          },
          icon: Icon(
            // Display a filled star if the index is less than the current rating
            index < rating ? Icons.star : Icons.star_border, // Filled or outlined star
            color: index < rating ? Colors.amber : Colors.grey, // Yellow for selected, grey for unselected
            size: 30,
          ),
        );
      }),
    );
  }

  /// Creates a custom icon button with a label.
  /// This widget handles its tap event via the [onTap] callback.
  Widget iconButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.black),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Displays the profile picture in a dialog.
  /// The dialog allows the user to interactively view the image and dismiss it by tapping.
  void showProfilePicture() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            // Close the dialog on tap
            onTap: () => Navigator.pop(context),

            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: profilePicture.startsWith("http")
                    ? Image.network(profilePicture, fit: BoxFit.contain)
                    : Image.asset(profilePicture, fit: BoxFit.contain),
                ),
              ),
            ),

        );
      },
    );
  }
}
