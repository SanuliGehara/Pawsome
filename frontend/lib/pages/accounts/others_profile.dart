import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/new_post.dart';
import 'package:pawsome/pages/home/home.dart';
import '../../reusable_widgets/CommunityWidgets.dart';
import '../../reusable_widgets/reusable_widget.dart';
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
        profilePicture = userDoc['profilePic'];
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
                  onTap:  () {
                    ProfilePictureViewer.show(context, profilePicture);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profilePicture.startsWith('http')
                        ? NetworkImage(profilePicture)
                        : AssetImage ("assets/images/no_profile_pic.png"),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  username,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFollowing ? Colors.pink[150] :Colors.pink[100],
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isFollowing ? "Unfollow"  : "Follow"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: openChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Chat"),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Posts",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),

                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _buildGrid(posts),
            ),
          ),

        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 4),


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

