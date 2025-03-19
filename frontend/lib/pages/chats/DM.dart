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

  @override
  void initState() {
    super.initState();
    _webSocketService.connect(widget.userName);

    _webSocketService.stream.listen((data) {
      setState(() {
        messages.add({"isMe": false, "text": data});
      });
    });
  }

  void sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _webSocketService.sendMessage(
        _messageController.text.trim(),
        widget.userName, // Assuming the sender is the logged-in user
        "receiver_username", // Replace with actual receiver username
      );

      setState(() {
        messages.add({"isMe": true, "text": _messageController.text.trim()});
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
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
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(messages[index]["text"]),
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
