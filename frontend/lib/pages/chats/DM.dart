import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/websocket_service.dart';

class DM extends StatefulWidget {
  final String userName;
  final String profilePic;

  const DM({Key? key, required this.userName, required this.profilePic}) : super(key: key);

  @override
  _DMState createState() => _DMState();
}

class _DMState extends State<DM> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String receiverUserName = "receiver_username"; // Replace dynamically

  @override
  void initState() {
    super.initState();
    _webSocketService.connect(widget.userName);

    // Listen for real-time WebSocket messages
    _webSocketService.stream.listen((data) {
      print("Received message: $data"); // Debugging print
      setState(() {
        messages.add({"isMe": false, "text": data});
      });
    });

    // Fetch previous messages from Firestore
    _loadPreviousMessages();
  }

  void _loadPreviousMessages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where("participants", arrayContains: widget.userName) // Matches chats where the user is involved
        .orderBy("timestamp", descending: false)
        .get();

    setState(() {
      messages = querySnapshot.docs.map((doc) => {
        "isMe": doc["sender"] == widget.userName,
        "text": doc["text"],
      }).toList();
    });
  }

  void sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      _webSocketService.sendMessage(messageText, widget.userName, receiverUserName);

      // Save message to Firestore
      FirebaseFirestore.instance.collection('messages').add({
        "sender": widget.userName,
        "receiver": receiverUserName,
        "text": messageText,
        "timestamp": FieldValue.serverTimestamp(),
        "participants": [widget.userName, receiverUserName], // For efficient querying
      });

      setState(() {
        messages.add({"isMe": true, "text": messageText});
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
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
          onPressed: () => Navigator.pop(context),
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
      body: Column(
        children: [
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
                          color: Colors.grey.withAlpha(50), // Used withAlpha() instead of withOpacity()
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
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
