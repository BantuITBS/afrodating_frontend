class ChatMessage {
  final int sessionId;
  final String sender;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.sessionId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        sessionId: json['session_id'],
        sender: json['sender'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'sender': sender,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };
}