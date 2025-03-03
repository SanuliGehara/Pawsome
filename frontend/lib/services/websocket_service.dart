import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  late IOWebSocketChannel _channel;

  void connect(String userId) {
    _channel = IOWebSocketChannel.connect('ws://yourserver.com/ws/chat/\$userId/');
  }

  void sendMessage(String message) {
    _channel.sink.add(jsonEncode({'message': message}));
  }

  Stream get stream => _channel.stream;

  void disconnect() {
    _channel.sink.close();
  }
}