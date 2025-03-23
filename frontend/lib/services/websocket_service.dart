import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  late IOWebSocketChannel _channel;
  final StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get stream => _controller.stream;

  void connect(String userName) {
    _channel = IOWebSocketChannel.connect('ws://your-backend-url/ws/chat/$userName/');

    _channel.stream.listen(
          (message) {
        _controller.add(message); // Add incoming messages to the stream
      },
      onDone: () {
        _controller.close(); // Close the stream if WebSocket disconnects
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
    );
  }

  void sendMessage(String message, String sender, String receiver) {
    final msg = jsonEncode({"text": message, "sender": sender, "receiver": receiver});
    _channel.sink.add(msg);
  }

  void disconnect() {
    _channel.sink.close();
    _controller.close();
  }
}
