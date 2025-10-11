
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

class ChatService {
  WebSocketChannel? channel;

  void connect() {
    channel = WebSocketChannel.connect(Uri.parse('wss://api.teaseme.co.za'));
    // Implement WebSocket logic
  }

  void dispose() {
    channel?.sink.close();
  }
}