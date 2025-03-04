import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pawsome/pages/chatbot/AiBot.dart';
import 'package:pawsome/pages/chats/Chat.dart';
import 'package:pawsome/pages/home/home.dart';

AppBar buildAppBar(String title) {
  return AppBar(
    title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    backgroundColor: Colors.amber[100],
    elevation: 0,
  );
}

Widget buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
Widget buildFeatureButton(String text, Color backgroundColor, Color textColor, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: textColor)),
    ),
  );
}

Widget buildPetCard(String description, String imagePath, bool isLiked, Function() onLikePressed) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Image.asset(imagePath, fit: BoxFit.cover, height: 150, width: double.infinity),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(description, textAlign: TextAlign.center),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border, // Toggle icon
                color: isLiked ? Colors.red : Colors.black, // Toggle color
              ),
              onPressed: onLikePressed, // Toggle state when clicked
            ),
            IconButton(icon: const Icon(Icons.comment), onPressed: () {}),
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          ],
        ),
      ],
    ),
  );
}

Widget buildBottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    selectedItemColor: Colors.orange,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
    ],
    onTap: (index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat()),
        );
      }
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AiBot()),
        );
      }
      // if (index == 4) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ProfilePage()),
      //   );
      // }
    },
  );
}
