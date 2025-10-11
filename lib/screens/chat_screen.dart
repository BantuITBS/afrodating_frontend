import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teaseme_flutter/models/chat_message.dart';
import 'package:teaseme_flutter/providers/chat_provider.dart';
import 'package:teaseme_flutter/services/chat_service.dart';
import 'package:teaseme_flutter/widgets/chat_bubble.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatProvider);
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Let’s Chat, Darling')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(
                  message: message.content,
                  isMe: message.sender == ref.read(authProvider).user?.username,
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
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Type something naughty...',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      final message = ChatMessage(
                        sessionId: 1, // Replace with actual session ID
                        sender: ref.read(authProvider).user?.username ?? '',
                        content: textController.text,
                        timestamp: DateTime.now(),
                      );
                      ref.read(chatProvider.notifier).addMessage(message);
                      ref.read(chatServiceProvider).sendMessage(textController.text);
                      textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}