import '../models/chat_model.dart';

class ChatbotRepository {
  Future<List<ChatHistoryItem>> getChatHistory() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ChatHistoryItem(
        title: 'Cara menghitung irisan dua himpu...',
        subtitle: 'Irisan dua himpunan A dan B adalah himpunan yang berisi...',
      ),
      ChatHistoryItem(
        title: 'Kenapa eksponen negatif hasilnya...',
        subtitle: 'Eksponen negatif seperti 2 pangkat negatif 3 sama dengan...',
      ),
      ChatHistoryItem(
        title: 'Contoh soal logaritma basis 2',
        subtitle: 'Berikut beberapa contoh soal logaritma basis 2 beserta...',
      ),
    ];
  }

  Future<List<ChatMessage>> getInitialMessages() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ChatMessage(
        sender: 'ai',
        message: 'Halo fariz! 👋 Aku NovaSight AI, siap membantu kamu memahami materi matematika. Ada yang ingin kamu tanyakan?',
        time: '09.15',
      ),
    ];
  }

  Future<ChatMessage> sendMessage(String message) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    final timeNow = '${DateTime.now().hour.toString().padLeft(2, '0')}.${DateTime.now().minute.toString().padLeft(2, '0')}';
    return ChatMessage(
      sender: 'ai',
      message: 'Ini adalah balasan simulasi dari NovaSight AI untuk: "$message"',
      time: timeNow,
    );
  }
}
