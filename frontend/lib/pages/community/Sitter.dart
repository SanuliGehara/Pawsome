import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/new_post.dart';
import 'Adopt.dart';
import 'Locate.dart';
import '../../reusable_widgets/CommunityWidgets.dart';

// Stateful widget to manage the Sitter page
class Sitter extends StatefulWidget {
  const Sitter({super.key});

  @override
  _SitterState createState() => _SitterState();
}

class _SitterState extends State<Sitter> {
  // List to track liked states for sitters (not currently used in UI but can be extended)
  List<bool> likedStates = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],  // Light grey background
      appBar: buildAppBar("Reliable Pet - Sitters"),  // Custom app bar with title
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the entire body in a SingleChildScrollView
          child: Column(  // Ensures smooth scrolling if content overflows vertically
            children: [
              buildSearchBar(), // Search bar for filtering sitters (from reusable widgets)

              // Feature navigation row with buttons for different sections
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFeatureButton("Adopt", Colors.grey, Colors.black, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Adopt()));
                  }),
                  buildFeatureButton("Locate", Colors.grey, Colors.black, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Locate()));
                  }),
                  buildFeatureButton(
                      "Sitter", Colors.orange, Colors.white, () {}),  // Current page
                ],
              ),
              const SizedBox(height: 10), // Spacing between elements

              // Grid layout for displaying available pet sitters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disables GridView's internal scrolling
                  shrinkWrap: true, // Allows GridView to adapt to its content size
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,  // Two sitters per row
                    crossAxisSpacing: 15, // Space between columns
                    mainAxisSpacing: 10,  // Space between rows
                    childAspectRatio: 0.8,  // Adjust height to width ratio of the cards
                  ),
                  itemCount: 4, // Placeholder count, could be dynamic based on API response
                  itemBuilder: (context, index) {
                    return buildPetSitterCard(
                      name: ["Oshadha", "Harry", "Sanjay", "Krish"][index],
                      location: ["Kandy", "Colombo", "Galle", "Colombo"][index],
                      rating: 5,
                      onTap: () {}, // Placeholder for action when clicking on a sitter
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action button to add a new sitter profile
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostPage()), // Creating new pet sitter profile
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber[700],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),  // Custom bottom nav bar
    );
  }

  // Widget for displaying a pet sitter card in the grid
  Widget buildPetSitterCard({
    required String name,
    required String location,
    required int rating,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),  // Rounded corners
        ),
        elevation: 4, // Adds a shadow for depth effect
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder profile picture
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/images/avatar3.png"),
            ),
            const SizedBox(height: 10), // Spacing

            // Display sitter's name
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            // Display location
            Text(
              location,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),

            // Star rating representation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                rating,
                    (index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}