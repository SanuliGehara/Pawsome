import 'package:flutter/material.dart';
import 'package:pawsome/pages/login_signup/reset_password.dart';
import 'package:pawsome/pages/login_signup/signup_page.dart';
import 'package:pawsome/pages/settings/Terms.dart';
import 'package:pawsome/services/database_service.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool notifications = true;
  bool sms = true;
  bool location = false;

  // Create instance of databaseService for firebase related functionalities
  DatabaseService _databaseService = new DatabaseService();

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
            Text("Permissions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
            Text("Manage Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ListTile(
              title: Text("Delete Account & Data", style: TextStyle(color: Theme.of(context).iconTheme.color)),
              onTap: () async {
                // Show a confirmation dialog
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Account?"),
                      content: const Text(
                          "Are you sure you want to delete your account and all associated data? This action cannot be undone."),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                );

                // If user confirmed, proceed to delete the account
                if (confirm == true) {
                  try {
                    await _databaseService.deleteCurrentUser(context);

                    // Show success message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account deleted successfully."),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Navigate back or to a signUp screen
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignupPage()));
                    }
                  } catch (error) {
                    // Show error message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error deleting account: $error"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
            SizedBox(height: 16),
            Text("Security Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ListTile(
              title: Text("Change Password", style: TextStyle(color: Theme.of(context).iconTheme.color)),
              onTap: () {
                // Navigate to change password screen
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPassword())); // Navigate to Login after logging out
              },
            ),
            SizedBox(height: 16),
            Text("Read Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ListTile(
              title: Text("Read Privacy Policy", style: TextStyle(color: Theme.of(context).iconTheme.color)),
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

