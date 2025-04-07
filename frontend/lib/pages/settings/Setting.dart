import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/accounts/own_profile.dart';
import 'package:pawsome/pages/accounts/pet_sitter/pet_sitter_profile_owner.dart';
import 'package:pawsome/pages/login_signup/login_page.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:pawsome/pages/settings/About.dart';
import 'package:pawsome/pages/settings/Help.dart';
import 'package:pawsome/pages/settings/Privacy.dart';
import 'package:pawsome/pages/settings/Terms.dart';
import 'package:pawsome/main.dart'; // Import ThemeProvider

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // Local state for Notifications toggle
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    // Access the current ThemeProvider to toggle light/dark mode
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),  // Navigate back
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search settings',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          /// Main content list
          Expanded(
            child: ListView(
              children: [
                /// Notifications Switch
                SwitchListTile(
                  title: Text('Notifications'),
                  secondary: Icon(Icons.notifications),
                  value: _notificationsEnabled,
                  activeColor: Colors.orange,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                /// Dark Mode Toggle
                SwitchListTile(
                  title: Text('Dark Mode'),
                  secondary: Icon(Icons.dark_mode),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  activeColor: Colors.orange,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                  onTap: () async {
                    try {
                      /// Get current user ID
                      String userId = FirebaseAuth.instance.currentUser?.uid ?? "CJcHnkxI1GZY04aAYTmy";

                      /// Fetch user document from Firestore
                      DocumentSnapshot userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get();

                      /// Get user category
                      String userType = userDoc['category'];

                      // Navigate based on category
                      if (userType.toLowerCase() == 'pet sitter') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PetSitterProfileOwnerPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      }
                    } catch (e) {
                      print('Error fetching user data: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to load account. Please try again.')),
                      );
                    }
                  }
                ),
                /// About Page
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => About()),
                  ),
                ),
                /// Privacy & Security Page
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Privacy & Security'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Privacy()),
                  ),
                ),
                /// Terms & Conditions Page
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Terms & Conditions'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Terms()),
                  ),
                ),
                /// Help & Support Page
                ListTile(
                  leading: Icon(Icons.support),
                  title: Text('Help & Support'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help()),
                  ),
                ),
                /// Logout & redirect to login screen
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                     showCustomSnackBar(context, "User Logged Out Successfully!", Colors.green);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())); // Navigate to Login after logging out
                    }
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
