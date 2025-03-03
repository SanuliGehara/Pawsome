import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class AiBot extends StatefulWidget {
  const AiBot({Key? key}) : super(key: key);

  @override
  _AiBotState createState() => _AiBotState();
}

class _AiBotState extends State<AiBot> {
  late WebSocketChannel channel;
  List<Map<String, dynamic>> messages = [];

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Replace 'yourserver.com' with your actual backend WebSocket URL
    channel = WebSocketChannel.connect(
      Uri.parse("ws://localhost:8000/ws/chat/1/"),
    );

    // Listen for messages from WebSocket
    channel.stream.listen((message) {
      setState(() {
        messages.add({"isMe": false, "text": message});
      });
    });
  }

  void sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({"isMe": true, "text": _messageController.text.trim()});
      });

      // Send message to WebSocket server
      channel.sink.add(_messageController.text.trim());
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
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
              backgroundImage: AssetImage('assets/images/chatbot.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              "Chatbot",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
