import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  late WebSocketChannel _channel;

  /// Connect to WebSocket
  void connect(String username) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/chat/$username/'),
    );

    // Listen for messages
    _channel.stream.listen(
          (message) {
        print('Received: $message');
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Connection closed');
      },
    );
  }

  /// Send message
  void sendMessage(String sender, String receiver, String text) {
    _channel.sink.add(
      '{"sender": "$sender", "receiver": "$receiver", "text": "$text"}',
    );
  }

  /// Disconnect WebSocket
  void disconnect() {
    _channel.sink.close(status.goingAway);
  }
}
