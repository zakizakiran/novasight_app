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
        message: 'Halo! 👋 Aku NovaSight AI. Ada materi matematika yang bikin kamu bingung hari ini?',
        time: '09.15',
      ),
    ];
  }

  Future<ChatMessage> sendMessage(String message) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    final timeNow = '${DateTime.now().hour.toString().padLeft(2, '0')}.${DateTime.now().minute.toString().padLeft(2, '0')}';
    
    String aiResponse = '';
    final lowerMsg = message.toLowerCase();

    if (lowerMsg.contains('pangkat') || lowerMsg.contains('eksponen')) {
      aiResponse = 'Gampang kok! Eksponen negatif itu artinya kebalikan. Misalnya 2 pangkat -3, itu sama dengan 1 dibagi 2 pangkat 3 (1/2³). Hasilnya jadi 1/8. Paham kan? 😉';
    } else if (lowerMsg.contains('pecahan')) {
      aiResponse = 'Kalau pecahan dipangkatkan negatif, tinggal dibalik aja pecahannya lalu dipangkatkan positif. Misal (2/3)⁻² jadinya (3/2)², yang berarti 9/4.';
    } else if (lowerMsg.contains('makasih') || lowerMsg.contains('terima kasih') || lowerMsg.contains('paham')) {
      aiResponse = 'Sama-sama! Jangan ragu buat tanya lagi kalau ada soal yang susah ya. Semangat belajarnya! 🚀';
    } else {
      aiResponse = 'Wah, pertanyaan yang bagus! Coba jelaskan lebih detail angka atau soalnya supaya aku bisa bantu hitung ya.';
    }

    return ChatMessage(
      sender: 'ai',
      message: aiResponse,
      time: timeNow,
    );
  }
}
