import 'package:flutter/material.dart';
import 'chat_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawsome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(username: "Hafsa"),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool isFollowing = false;
  String username = "Hafsa";
  String bio = "sample bio............................................................................................................................................................................................................................................................................................................................................";
  String profilePicture = "https://via.placeholder.com/150";
  List<String> posts = List.generate(15, (index) => "https://via.placeholder.com/100");
  List<String> savedPosts = List.generate(5, (index) => "https://via.placeholder.com/100");

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;

    });
  }

  void openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        backgroundColor: Colors.yellow[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profilePicture),
                ),
                SizedBox(height: 10),
                Text(
                  username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFollowing ? Colors.red[300] :Colors.pink[100],
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isFollowing ? "Unfollow"  : "Follow"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: openChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Chat"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.yellow[200],
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: "   Posts   "),
                    Tab(text: "Saved Posts"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGrid(posts),
                _buildGrid(savedPosts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<String> images) {
    return images.isEmpty
        ? const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text("No Posts Yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    )
        : GridView.builder(
      physics:const BouncingScrollPhysics(),
      itemCount: images.length,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Material(
            color: Colors.transparent,
            child: InkWell(

          child: Image.network(images[index], fit: BoxFit.cover),
        ),
        );
      },
    );
  }
}

