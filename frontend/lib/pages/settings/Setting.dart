import 'package:flutter/material.dart';
import 'package:pawsome/pages/settings/About.dart';
import 'package:pawsome/pages/settings/Privacy.dart';
import 'package:pawsome/pages/settings/Terms.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _notificationsEnabled = false;
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.notifications, 'title': 'Notifications'},
    {'icon': Icons.person, 'title': 'Account'},
    {'icon': Icons.info, 'title': 'About'},
    {'icon': Icons.security, 'title': 'Privacy & Security'},
    {'icon': Icons.description, 'title': 'Terms & Conditions'},
    {'icon': Icons.support, 'title': 'Help & Support'},
    {'icon': Icons.logout, 'title': 'Logout'},
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  child: index == 0
                      ? SwitchListTile(
                    title: Text(items[index]['title']),
                    secondary: Icon(items[index]['icon']),
                    value: _notificationsEnabled,
                    activeColor: Colors.orange,
                    onChanged: (bool value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  )
                      : ListTile(
                    leading: Icon(items[index]['icon']),
                    title: Text(items[index]['title']),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });

                      if (items[index]['title'] == 'About') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => About(),
                          ),
                        );
                      }
                      if (items[index]['title'] == 'Terms & Conditions') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Terms(),
                          ),
                        );
                      }
                      if (items[index]['title'] == 'Privacy & Security') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Privacy(),
                          ),
                        );
                      }

                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

