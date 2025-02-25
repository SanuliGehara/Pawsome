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
  List<bool> likedStates = List.generate(6, (index) => false);

  void _showCommentBox(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: "Write a comment...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String comment = commentController.text.trim();
                if (comment.isNotEmpty) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Post"),
            ),
          ],
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[200],
  //     appBar: buildAppBar("Find a Pet Sitter"),
  //     body: Column(
  //       children: [
  //         buildSearchBar(),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             buildFeatureButton("Adopt", Colors.grey, Colors.black, () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) => const Adopt()));
  //             }),
  //             buildFeatureButton("Locate", Colors.grey, Colors.black, () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) => const Locate()));
  //             }),
  //             buildFeatureButton("Sitter", Colors.orange, Colors.white, () {}),
  //           ],
  //         ),
  //         Expanded(
  //           child: GridView.builder(
  //             padding: const EdgeInsets.all(10),
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               crossAxisSpacing: 15,
  //               mainAxisSpacing: 10,
  //               childAspectRatio: 0.85,
  //             ),
  //             itemCount: 6,
  //             itemBuilder: (context, index) {
  //               return buildPetCard(
  //                 "Sitter available: Sarah, 3 years experience",
  //                 "assets/avatar1.jpg",
  //                 likedStates[index],
  //                     () {
  //                   setState(() {
  //                     likedStates[index] = !likedStates[index];
  //                   });
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: buildBottomNavigationBar(context, 3),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar("Find a Pet Sitter"),
      body: SingleChildScrollView( // Wrap entire body with SingleChildScrollView
        child: Column(
          children: [
            buildSearchBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFeatureButton("Adopt", Colors.grey, Colors.black, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Adopt()));
                }),
                buildFeatureButton("Locate", Colors.grey, Colors.black, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Locate()));
                }),
                buildFeatureButton("Sitter", Colors.orange, Colors.white, () {}),
              ],
            ),
            GridView.builder(
              shrinkWrap: true, // Makes GridView take up only the space it needs
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return buildPetCard(
                  "Sitter available: Sarah, 3 years experience",
                  "assets/avatar1.jpg",
                  likedStates[index],
                      () {
                    setState(() {
                      likedStates[index] = !likedStates[index];
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: buildBottomNavigationBar(context, 3),
      bottomNavigationBar: Container(
        height: 60, // Adjust this value to fit better
        child: buildBottomNavigationBar(context, 3),
      ),

    );
  }


  Widget buildPetCard(String description, String imagePath, bool isLiked, VoidCallback onLikePressed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.asset(imagePath, fit: BoxFit.cover, height: 120, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.black),
                onPressed: onLikePressed,
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => _showCommentBox(context),
              ),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
