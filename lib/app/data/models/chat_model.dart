class ChatHistoryItem {
  final String title;
  final String subtitle;

  ChatHistoryItem({
    required this.title,
    required this.subtitle,
  });
}

class ChatMessage {
  final String sender; // 'ai' or 'user'
  final String message;
  final String time;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.time,
  });
}
