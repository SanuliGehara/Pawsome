import 'package:flutter/material.dart';
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
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
          Expanded(
            child: ListView(
              children: [
                // Notifications Switch
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
                // Dark Mode Toggle
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
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => About()),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Privacy & Security'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Privacy()),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Terms & Conditions'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Terms()),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.support),
                  title: Text('Help & Support'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help()),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
