import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatBubble({required this.message, required this.isMe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.amber[200] : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message),
      ),
    );
  }
}
