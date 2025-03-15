import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;
  StreamController<String> _streamController = StreamController.broadcast();

  // Connect WebSocket
  void connect(String userName) {
    try {
      _channel = IOWebSocketChannel.connect("ws://127.0.0.1:8000/ws/chat/");
      _channel!.stream.listen(
        (message) {
          final decodedMessage = jsonDecode(message);
          _streamController.add(decodedMessage["message"]);
        },
        onError: (error) {
          print("WebSocket error: $error");
        },
        onDone: () {
          print("WebSocket connection closed.");
        },
      );
    } catch (e) {
      print("Error connecting to WebSocket: $e");
    }
  }

  // Stream messages
  Stream<String> get stream => _streamController.stream;

  // Send message
  void sendMessage(String message) {
    if (_channel != null && message.trim().isNotEmpty) {
      _channel!.sink.add(jsonEncode({"message": message}));
    }
  }

  // Close WebSocket
  void disconnect() {
    _channel?.sink.close();
  }
}
