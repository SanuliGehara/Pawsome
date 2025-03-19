import 'package:flutter/material.dart';
import 'dart:convert';
import '../../services/websocket_service.dart';

class DM extends StatefulWidget {
  final String userName;  // Name of the chat recipient
  final String profilePic;  // Profile picture of the chat recipient

  const DM({Key? key, required this.userName, required this.profilePic}) : super(key: key);

  @override
  _DMState createState() => _DMState();
}

class _DMState extends State<DM> {
  final WebSocketService _webSocketService = WebSocketService();  // WebSocket service for real-time chat
  final TextEditingController _messageController = TextEditingController(); // Controller for text input field
  List<Map<String, dynamic>> messages = [];  // List to store chat messages

  @override
  void initState() {
    super.initState();
    _webSocketService.connect(widget.userName); // Connect to WebSocket server with username
    // _webSocketService.stream.listen((data) {  // Listen for incoming messages from the WebSocket stream
    //   setState(() {
    //     messages.add({"isMe": false, "text": data});  // Add received message to the chat
    //   });
    // });
  }
  // Function to send a message
  void sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      //_webSocketService.sendMessage(_messageController.text); // Send message via WebSocket
      setState(() {
        messages.add({"isMe": true, "text": _messageController.text.trim()}); // Add sent message to chat
      });
      _messageController.clear(); // Clear input field after sending
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect(); // Disconnect WebSocket when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100], // Light amber background
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),  // Back button
          onPressed: () => Navigator.pop(context),  // Navigate back on top
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.profilePic), // Display profile picture
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.userName,  // Display username
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),  // Add padding around chat messages
              itemCount: messages.length, // Count of messages
              itemBuilder: (context, index) {
                bool isMe = messages[index]["isMe"];   // Determine if the message is sent by the user
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, // Align messages accordingly
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),  // Add vertical spacing between messages
                    padding: const EdgeInsets.all(12),  // Padding inside the message bubble
                    decoration: BoxDecoration(
                      color: isMe ? Colors.amber[200] : Colors.white,  // Different colors for user and recipient messages
                      borderRadius: BorderRadius.circular(15),  // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),  // Light shadow for depth
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(messages[index]["text"]), // Display message text
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Padding for input area
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)), // Thin border for separation
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController, // Connect text field to controller
                    decoration: const InputDecoration(
                      hintText: "Type a message...",  // Placeholder text
                      border: InputBorder.none, // No border
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.amber),  // Send button
                  onPressed: sendMessage, // Call sendMessage function on tap
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}