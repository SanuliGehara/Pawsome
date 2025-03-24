import 'package:flutter/material.dart';
import '../../services/websocket_service.dart';

/// DM screen (Direct Message) that handles real-time chat with WebSocket support
class DM extends StatefulWidget {
  /// Name of the user being chatted with
  final String userName;
  /// Profile picture of the chat user
  final String profilePic;

  const DM({Key? key, required this.userName, required this.profilePic}) : super(key: key);

  @override
  _DMState createState() => _DMState();
}

class _DMState extends State<DM> {
  /// Service to handle WebSocket connections
  final WebSocketService _webSocketService = WebSocketService();
  /// Controller for the message input field
  final TextEditingController _messageController = TextEditingController();
  /// List to store chat messages
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    /// Establish WebSocket connection using the chat partner's username
    _webSocketService.connect(widget.userName);

    /// Listen for incoming messages from the stream
    _webSocketService.stream.listen((data) {

      /// Debug log for received messages
      print("Received message: $data");

      /// Add received message to UI as a "not me" message
      setState(() {
        messages.add({"isMe": false, "text": data});
      });
    });
  }

  /// Handles sending a message
  void sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      /// Send message via WebSocket
      _webSocketService.sendMessage(
        messageText,
        widget.userName, // Assuming sender is logged-in user
        "receiver_username", // Replace with actual receiver username
      );

      /// Add sent message to the local UI
      setState(() {
        messages.add({"isMe": true, "text": messageText});
      });

      /// Clear input field after sending
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    /// Clean up WebSocket connection and controller
    _webSocketService.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),  // Return to previous screen
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.profilePic),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.userName,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      /// Main chat UI body
      body: Column(
        children: [
          /// Message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isMe = messages[index]["isMe"];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.amber[200] : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(50), // Replaced withAlpha()
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(messages[index]["text"] ?? "No message"),
                  ),
                );
              },
            ),
          ),

          /// Input field and send button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                /// Message input field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                /// Send button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.amber),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
