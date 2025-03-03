import 'package:flutter/material.dart';
import 'Adopt.dart';
import 'Locate.dart';
import '../../reusable_widgets/CommunityWidgets.dart';

class Sitter extends StatefulWidget {
  const Sitter({super.key});

  @override
  _SitterState createState() => _SitterState();
}

class _SitterState extends State<Sitter> {
  List<bool> likedStates = List.generate(4, (index) => false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar("Reliable Pet - Sitters"),
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the entire body in a SingleChildScrollView
          child: Column(
            children: [
              buildSearchBar(),
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
                      "Sitter", Colors.orange, Colors.white, () {}),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                  shrinkWrap: true, // Allow GridView to take only the space it needs
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 4, // Adjust based on actual data
                  itemBuilder: (context, index) {
                    return buildPetSitterCard(
                      name: ["Oshadha", "Harry", "Sanjay", "Krish"][index],
                      location: ["Kandy", "Colombo", "Galle", "Colombo"][index],
                      rating: 5,
                      onTap: () {},
                    );
                  },
                ),
              ),
              //const SizedBox(height: 60), // Add some space before the bottom navigation bar
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildPetCard("New Post", "assets/kitten.jpg", false, () {}); // Placeholder
        },
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber[700],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

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
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/images/avatar3.png"),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              location,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
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