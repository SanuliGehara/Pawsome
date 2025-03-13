import 'package:flutter/material.dart';
import 'package:pawsome/pages/settings/Terms.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool notifications = true;
  bool sms = true;
  bool location = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy & Security"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Permissions", style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: Text("Notifications"),
              value: notifications,
              activeColor: Colors.orange, // Toggle on color
              onChanged: (value) => setState(() => notifications = value),
            ),
            SwitchListTile(
              title: Text("SMS"),
              value: sms,
              activeColor: Colors.orange, // Toggle on color
              onChanged: (value) => setState(() => sms = value),
            ),
            SwitchListTile(
              title: Text("Location"),
              value: location,
              activeColor: Colors.orange, // Toggle on color
              onChanged: (value) => setState(() => location = value),
            ),
            SizedBox(height: 16),
            Text("Manage Data", style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text("Delete Account & Data", style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to delete account screen
              },
            ),
            SizedBox(height: 16),
            Text("Security Settings", style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text("Change Password", style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to change password screen
              },
            ),
            SizedBox(height: 16),
            Text("Read Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text("Read Privacy Policy", style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to privacy policy screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Terms(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

