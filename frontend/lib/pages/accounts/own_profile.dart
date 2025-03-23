
import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/new_post.dart';
import 'package:pawsome/pages/home/home.dart';
import '../../reusable_widgets/CommunityWidgets.dart';
import '../../reusable_widgets/reusable_widget.dart';
import 'edit_profile.dart';
import 'post_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: HomePage()
    );
  }
}

class ProfilePage extends StatefulWidget {

  final bool isOwnProfile;

  const ProfilePage({super.key,this.isOwnProfile = true});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  String username = "";
  String bio = "";
  String profilePicture = "";
  List<String> posts = [];
  List<String> savedPosts =[];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserProfile();

  }



  Future<void> _fetchUserProfile() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid??"s1tJsaeEjKSHPNnq5efT";
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
      List<String> savedPostIds = List<String>.from(userDoc['savedPosts'] ?? []);//getting the saved posts ids
      List<String> savedPostImages = [];
      //iterating through saved post ids
      if (savedPostIds.isNotEmpty) {
        QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where(FieldPath.documentId, whereIn: savedPostIds)
            .get();
        savedPostImages = postsSnapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      }
      setState(() {
        username = userDoc['username'];
        bio = userDoc['description'];
        profilePicture = userDoc['profilePicture'] ?? "assets/images/no_profile_pic.png";
        posts = List<String>.from(userDoc['posts'] ?? []);
        savedPosts = savedPostImages;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),

        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap:  () {
                    ProfilePictureViewer.show(context, profilePicture);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profilePicture.startsWith('http')
                        ? NetworkImage(profilePicture)
                        : AssetImage ("assets/images/no_profile_pic.png"),
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

                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  ),
                  child: Text("Edit Profile"),
                )
                    : Container(),
                SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.orange,
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
                _buildGrid(posts),//displaying all posts
                _buildGrid(savedPosts),//displaying all saved posts
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 4),
      floatingActionButton: FloatingActionButton(
        onPressed: addPost,
        backgroundColor: Colors.orange[200],
        child: Icon(Icons.add),
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
                    username: username,
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
