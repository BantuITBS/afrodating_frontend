import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teaseme_flutter/models/chat_message.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) => ChatNotifier());

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  Future<void> fetchMessages(int sessionId) async {
    // WebSocket handled in chat_service.dart
  }
}