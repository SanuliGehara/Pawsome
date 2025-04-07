import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/community/new_post.dart';
import '../../reusable_widgets/community_widgets.dart';
import '../../reusable_widgets/reusable_widget.dart';
import '../chats/DM.dart';
import 'post_detail_screen.dart';

//profile page widget (when viewing others profile pages)
class ProfilePage extends StatefulWidget {
  final String userId;
  final bool isOwnProfile;

  const ProfilePage({super.key, required this.userId, this.isOwnProfile = false});
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

  //fetch user data from firebase
  Future<void> fetchUserData() async {
    try {
      //get user document of the user with relevant userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      setState(() {
        username = userDoc['username'];
        bio = userDoc['description'];
        profilePicture = userDoc['profilePicture'];
        posts = List<String>.from(userDoc['posts']);
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  //toggle follow state
  void toggleFollow() async {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  //Navigation to relevant direct message screen functionality
  void openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DM(
        userName: username, // Pass the profile user's name
        profilePic: profilePicture, // Pass the profile picture URL
      ),
      ),
    );
  }

  //navigate to create post page
  void addPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostPage()),
    );
  }

  //post grid widget
  Widget _buildGrid(List<String> images) {

    //if no posts
    return images.isEmpty
        ? const Center(
      //return message and an icon
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
      physics:const BouncingScrollPhysics(), //makes the scroll bounce at the edges
      itemCount: images.length,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5, //space between items
        mainAxisSpacing: 5, //space between rows
        childAspectRatio: 1, //width.height ratio
      ),

      itemBuilder: (context, index) {
        return Material(
          color: Colors.transparent,
          child: InkWell( //make item clickable
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(
                    imageUrl: images[index], //current image url
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

          //user info section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                InkWell(
                  //user profile picture
                  child: CircleAvatar(
                    radius: 50,
                    //if profile picture contains an url load it,otherwise show default profile pic
                    backgroundImage: profilePicture.startsWith('http')
                        ? NetworkImage(profilePicture)
                        : AssetImage ("assets/images/no_profile_pic.png"),
                  ),
                  //when profile picture clicked,you can view it
                  onTap:  () {
                    ProfilePictureViewer.show(context, profilePicture);
                  },
                ),

                SizedBox(height: 10),

                //displaying username
                Text(
                  username,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                //displaying bio
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
                    //follow button
                    ElevatedButton(
                      onPressed: toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFollowing ? Colors.pink[150] :Colors.orange[100],
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isFollowing ? "Unfollow"  : "Follow"),
                    ),

                    SizedBox(width: 10),

                    //Chat button
                    ElevatedButton(
                      onPressed: openChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[100],
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

          //user post section
          Expanded(
            child: Container(
              color: Colors.grey[100],
              //utilizing grid widget
              child: _buildGrid(posts),
            ),
          ),
        ],
      ),
      //navigation bar
      bottomNavigationBar: buildBottomNavigationBar(context, 4),
    );
  }
}

