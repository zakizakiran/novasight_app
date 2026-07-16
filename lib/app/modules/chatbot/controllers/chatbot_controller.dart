import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/chat_model.dart';
import 'package:novasight_app/app/data/repositories/chatbot_repository.dart';

class ChatbotController extends GetxController {
  final ChatbotRepository repository;

  ChatbotController({required this.repository});

  final isChatActive = false.obs;

  final chatHistory = <ChatHistoryItem>[].obs;
  final messages = <ChatMessage>[].obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();
  final hasInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      hasInput.value = textController.text.trim().isNotEmpty;
    });
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    chatHistory.value = await repository.getChatHistory();
    messages.value = await repository.getInitialMessages();
  }

  void startNewChat() {
    isChatActive.value = true;
  }

  void openChat(int index) {
    isChatActive.value = true;
  }

  void backToHistory() {
    isChatActive.value = false;
  }

  Future<void> sendMessage() async {
    if (textController.text.trim().isEmpty) return;

    final userMessage = textController.text;
    textController.clear();

    final timeNow = '${DateTime.now().hour.toString().padLeft(2, '0')}.${DateTime.now().minute.toString().padLeft(2, '0')}';

    messages.add(ChatMessage(
      sender: 'user',
      message: userMessage,
      time: timeNow,
    ));

    _scrollToBottom();

    // Call repository to send message and get response
    final response = await repository.sendMessage(userMessage);
    messages.add(response);
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
