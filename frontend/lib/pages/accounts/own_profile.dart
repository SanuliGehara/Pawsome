import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/new_post.dart';
import 'package:pawsome/pages/home/home.dart';
import '../chats/Chat.dart';
import 'edit_profile.dart';
import 'post_detail_screen.dart';

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
      home: ProfilePage(username: "Hafsa", isOwnProfile: true),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String username;
  final bool isOwnProfile;

  const ProfilePage({super.key, required this.username, this.isOwnProfile = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  String username = "Profile Name";
  String bio = "sample bio............................................................................................................................................................................................................................................................................................................................................";
  String profilePicture = "assets/images/avatar1.jpg";
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

  void showProfilePicture() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  profilePicture,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void editProfile() {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePage(
            username: username,
            bio: bio,
            profilePicture: profilePicture,
            onSave: (newUsername, newBio, newProfilePic) {
              setState(() {
                username = newUsername;
                bio = newBio;
                profilePicture = newProfilePic;
              });
            },
          ),
        ),
      );
    }

  void addPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostPage()),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: showProfilePicture,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(profilePicture),
                  ),
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
                widget.isOwnProfile
                    ? ElevatedButton(
                  onPressed: editProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[100],
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Edit Profile"),
                )
                    : Container(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: addPost,
        backgroundColor: Colors.orange[100],
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBar(currentIndex: 4),
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
      physics: const BouncingScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(
                    imageUrl: images[index],
                    username: widget.username,
                    profileImage: profilePicture,
                  ),
                ),
              );
            },
            child: Image.network(images[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
