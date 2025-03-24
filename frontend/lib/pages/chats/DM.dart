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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
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
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                Color bubbleColor = isMe
                    ? (isDark ? Colors.amber[300]! : Colors.amber[200]!)
                    : Theme.of(context).cardColor;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05), // Used withAlpha() instead of withOpacity()
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(messages[index]["text"] ?? "No message", style: textTheme.bodyMedium,),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
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
