import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<String> profileNames = [
    'John Doe',
    'Jane Smith',
    'Michael Johnson',
    'Emily Davis',
    'Chris Brown',
    'Sophia Wilson',
    'Daniel Lee',
    'Olivia Martinez',
  ];

  List<String> profileImages = [
    "images/s1.jpg",
    "images/s2.jpg",
    "images/s3.jpg",
    "images/s4.jpg",
    "images/s5.jpg",
    "images/s6.jpg",
    "images/s7.jpg",
    "images/s8.jpg",
  ];

  String query = ""; // Search query

  @override
  Widget build(BuildContext context) {
    // Filtered list of profiles based on the search query
    final filteredProfiles = profileNames
        .asMap()
        .entries
        .where((entry) => entry.value.toLowerCase().contains(query.toLowerCase()))
        .map((entry) => {
      'name': entry.value,
      'image': profileImages[entry.key],
    })
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background
            borderRadius: BorderRadius.circular(10), // Rounded edges
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                query = value; // Update the query when the user types
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: "Search profiles...",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: filteredProfiles.map((profile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(profile['image']!), // Profile image
                      ),
                      SizedBox(width: 10),
                      Text(
                        profile['name']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          // Add action for more options
                        },
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
