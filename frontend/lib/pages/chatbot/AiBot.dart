import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// Stateful widget for AI chatbot
class AiBot extends StatefulWidget {
  const AiBot({Key? key}) : super(key: key);

  @override
  _AiBotState createState() => _AiBotState();
}

class _AiBotState extends State<AiBot> {
  late WebSocketChannel channel;  // Websocket channel for communication
  List<Map<String, dynamic>> messages = []; // List to store chat message

  final TextEditingController _messageController = TextEditingController(); // Controller for input field

  @override
  void initState() {
    super.initState();
    // Establish connection to WebSocket server
    // Replace 'yourserver.com' with your actual backend WebSocket URL
    channel = WebSocketChannel.connect(
      Uri.parse("ws://localhost:8000/ws/chat/1/"),
    );

    // Listen for incoming messages from WebSocket server
    channel.stream.listen((message) {
      setState(() {
        messages.add({"isMe": false, "text": message}); // Add received message as a bot response
      });
    });
  }

  // Function to send a message
  void sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        // Store user's message in the chat list
        messages.add({"isMe": true, "text": _messageController.text.trim()}); // Add sent message to chat
      });

      // Send message to WebSocket server
      channel.sink.add(_messageController.text.trim());
      _messageController.clear(); // Clear input field after sending
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway); // Close WebSocket connection when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100], // Light amber background color for app bar
        elevation: 0, // Remove shadow from app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),  // Back button
          onPressed: () => Navigator.pop(context),  // Navigate back when pressed
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/chatbot.png'), // Chatbot avatar
              radius: 20, // Set avatar radius
            ),
            const SizedBox(width: 10),  // Space between avatar and title
            const Text(
              "Chatbot",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Chatbot title styling
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),  // Padding around message list
              itemCount: messages.length, // Number of messages to display
              itemBuilder: (context, index) {
                bool isMe = messages[index]["isMe"];  // Check if message is from user or bot
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, // Align messages accordingly
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),  // Vertical spacing between messages
                    padding: const EdgeInsets.all(12),  // Padding inside message bubble
                    decoration: BoxDecoration(
                      color: isMe ? Colors.amber[200] : Colors.white, // Different colors for user and chatbot messages
                      borderRadius: BorderRadius.circular(15),  // Rounded corners for message bubble
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),  // Light shadow effect
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
              border: Border(top: BorderSide(color: Colors.grey.shade300)), // Top border for separation
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController, // Controller for input field
                    decoration: const InputDecoration(
                      hintText: "Type a message...",  // Placeholder text for input field
                      border: InputBorder.none, // Remove default input border
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.amber),  // Send button
                  onPressed: sendMessage, // Trigger sendMessage function when pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
