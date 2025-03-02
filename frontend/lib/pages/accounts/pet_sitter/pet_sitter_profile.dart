import 'package:flutter/material.dart';
import 'package:pawsome/pages/chats/Chat.dart';
import 'package:pawsome/reusable_widgets/CommunityWidgets.dart';

class PetSitterProfilePage extends StatefulWidget {
  const PetSitterProfilePage({super.key});

  @override
  _PetSitterProfilePageState createState() => _PetSitterProfilePageState();
}

class _PetSitterProfilePageState extends State<PetSitterProfilePage> {
  int likes = 40; // Initial like count
  double rating = 4; // Default rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0CC), // Light yellow
        elevation: 0,
        title: const Text(
          "Pet sitter name",
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
          // Full-Screen Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png", // Paw print background
              fit: BoxFit.cover, // ✅ Ensures full-screen coverage
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
                        const SizedBox(height: 20),

                        // Profile Image with Orange Border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.orange, width: 4),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage("assets/images/default_user.jfif"), // Profile Picture
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Username
                        inputField("pet sitter name"),
                        const SizedBox(height: 25),

                        // Description Box
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD9A5), // Light orange
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "I am an experienced pet sitter with 4 years of experience.",
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
                            iconButton(Icons.favorite_border, "$likes Likes", () {
                              setState(() {
                                likes++; // Increment likes on tap
                              });
                            }),
                            const SizedBox(width: 40),
                            iconButton(Icons.chat_bubble_outline, "Chat", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
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

      // Bottom Navigation Bar
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  // Styled Input Field (for Name)
  Widget inputField(String hint) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD9A5), // Light orange
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

  // Star Rating Widget
  Widget starRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              rating = index + 1.0; // Update rating dynamically
            });
          },
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border, // Filled or outlined star
            color: index < rating ? Colors.amber : Colors.grey, // Yellow for selected, grey for unselected
            size: 30,
          ),
        );
      }),
    );
  }

  // Icon Button (Likes & Chat)
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
}
