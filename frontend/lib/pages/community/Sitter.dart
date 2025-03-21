import 'package:flutter/material.dart';
import 'package:pawsome/pages/accounts/pet_sitter/pet_sitter_profile.dart';
import 'package:pawsome/pages/community/new_post.dart';
import '../../services/database_service.dart';
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

  // Instance of DatabaseService for fetch pet sitters.
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar("Reliable Pet Sitters"),  // Custom app bar with title
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the entire body in a SingleChildScrollView
          child: Column(  // Ensures smooth scrolling if content overflows vertically
            children: [
              buildSearchBar(), // Search bar for filtering sitters (from reusable widgets)

              // Feature navigation row with buttons for different sections
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFeatureButton("Adopt", Theme.of(context).cardColor, Theme.of(context).textTheme.bodyLarge!.color!, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Adopt()));
                  }),
                  buildFeatureButton("Locate", Theme.of(context).cardColor, Theme.of(context).textTheme.bodyLarge!.color!, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Locate()));
                  }),
                  buildFeatureButton(
                      "Sitter", Colors.orange, Colors.white, () {}),  // Current page
                ],
              ),
              const SizedBox(height: 10), // Spacing between elements

              /// Fetch pet sitters dynamically from Firestore
              StreamBuilder<List<Map<String, dynamic>>>(
              stream: _databaseService.getPetSitters(), // Get pet sitters
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading indicator
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No pet sitters available."));
              }

              List<Map<String, dynamic>> petSitters = snapshot.data!;

              // Grid layout for displaying available pet sitters
              return Padding(
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
                  itemCount: petSitters.length,
                  itemBuilder: (context, index) {
                    var sitter = petSitters[index];
                    return buildPetSitterCard(
                    name: sitter["username"] ?? "Unknown",
                    profilePicture: sitter["profilePicture"] ,
                    description: sitter["description"] ?? "No description",
                    rating: sitter["rating"] ?? 0, // Rating
                      onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PetSitterProfilePage(),
                        ),
                      );
                      },
                    );
                    },
                ),
              );
              },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),  // Custom bottom nav bar
    );
  }

  // Widget for displaying a pet sitter card in the grid
  Widget buildPetSitterCard({
    required String name,
    required String? profilePicture,
    required String description,
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
            // Profile picture with default fallback
            CircleAvatar(
              radius: 40,
              backgroundImage: (profilePicture != null && profilePicture.isNotEmpty)
                  ? NetworkImage(profilePicture)
                  : const AssetImage("assets/images/avatar3.png") as ImageProvider,
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

            // Display description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
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