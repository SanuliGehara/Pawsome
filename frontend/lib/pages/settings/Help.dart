import 'package:flutter/material.dart';

class Help extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text('Contact Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Email Support : pawsome469@gmail.com', style: TextStyle(fontSize: 14)),
            Text('Phone Support : 0770555619', style: TextStyle(fontSize: 14)),
            SizedBox(height: 32),
            Text('Community & Social Media', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Instagram : pawsome.lk.app', style: TextStyle(fontSize: 14)),
            Text('LinkedIn : pawsome.lk', style: TextStyle(fontSize: 14)),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
