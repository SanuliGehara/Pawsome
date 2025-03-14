import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class AiBot extends StatefulWidget {
  const AiBot({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<AiBot> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8000/ws/chat/1/"), // Adjust for your backend
    );

    _channel.stream.listen(
          (data) {
        final response = json.decode(data);
        setState(() {
          _messages.add({"type": "bot", "message": response['message']});
        });
      },
      onDone: () {
        print("WebSocket closed");
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"type": "user", "message": _controller.text});
      });

      _channel.sink.add(json.encode({'message': _controller.text}));
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["type"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["message"] ?? ""),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
