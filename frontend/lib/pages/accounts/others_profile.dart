import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/new_post.dart';
import 'package:pawsome/pages/home/home.dart';
import '../chats/Chat.dart';
import 'post_detail_screen.dart';


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
      home: ProfilePage(userId:"s1tJsaeEjKSHPNnq5efT"),
    );
  }
}
class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>  {
  bool isFollowing = false;
  String username = "";
  String bio = "";
  String profilePicture = "";
  List<String> posts =[];



  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      setState(() {
        username = userDoc['name'];
        bio = userDoc['bio'];
        profilePicture = userDoc['profilePicture'];
        posts = List<String>.from(userDoc['posts']);
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }



  void toggleFollow() async {


    setState(() {
      isFollowing = !isFollowing;
    });

  }

  void openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chat()),
    );
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
                child: Image.network(
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
  void addPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostPage()), // Navigate to CreatePostPage
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
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => HomePage()),

            );
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
                    backgroundImage: NetworkImage(profilePicture),
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
                Text(
                  "Posts",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                ),
              ],
            ),
          ),
          Expanded(child: _buildGrid(posts)),

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(
                    imageUrl: images[index],
                    username: username, // Pass the username
                    profileImage: profilePicture,),
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

