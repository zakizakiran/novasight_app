import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/data/models/chatbot_model.dart';
import 'package:lydera_app/app/data/repositories/chatbot_repository.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

class ChatbotController extends GetxController {
  final ChatbotRepository repository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ChatbotController({
    required this.repository,
    this.classroomRepository,
    this.storageService,
  });

  // Navigation & Active View state
  final RxBool isChatActive = false.obs;
  final RxnInt activeClassroomId = RxnInt();
  final RxnInt currentSessionId = RxnInt();

  // Sessions list state
  final RxBool isLoadingSessions = false.obs;
  final RxString sessionsErrorMessage = ''.obs;
  final RxList<ChatSessionResponseWithMessage> sessions =
      <ChatSessionResponseWithMessage>[].obs;

  // Messages in active session state
  final RxBool isLoadingMessages = false.obs;
  final RxString messagesErrorMessage = ''.obs;
  final RxList<ChatMessageResponse> messages = <ChatMessageResponse>[].obs;

  // Message sending & AI answer state
  final RxBool isSendingMessage = false.obs;
  final RxString sendErrorMessage = ''.obs;
  final RxList<String> suggestedQuestions = <String>[].obs;
  final RxList<SourceCitation> citations = <SourceCitation>[].obs;

  // Input & Scroll
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool hasInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      hasInput.value = textController.text.trim().isNotEmpty;
    });
    initChatbotData();
  }

  /// Initialize active classroom and load chat sessions
  Future<void> initChatbotData() async {
    try {
      isLoadingSessions.value = true;
      sessionsErrorMessage.value = '';

      if (classroomRepository != null) {
        final list = await classroomRepository!.getClassrooms();
        if (list.isNotEmpty) {
          final cachedCode = storageService?.getClassCode();
          final selected =
              list.firstWhereOrNull((c) => c.code == cachedCode) ?? list.first;
          activeClassroomId.value = selected.id;
        }
      }

      if (activeClassroomId.value != null) {
        await loadSessions();
      } else {
        // Fallback demo or empty
        sessions.clear();
      }
    } on ApiException catch (e) {
      sessionsErrorMessage.value = e.message;
    } catch (e) {
      sessionsErrorMessage.value =
          'Gagal memuat data sesi: ${e.toString()}';
    } finally {
      isLoadingSessions.value = false;
    }
  }

  /// Load existing chat sessions for the active classroom
  Future<void> loadSessions() async {
    if (activeClassroomId.value == null) return;

    try {
      isLoadingSessions.value = true;
      sessionsErrorMessage.value = '';

      final result = await repository.getSessions(
        classroomId: activeClassroomId.value!,
      );
      sessions.value = result;
    } on ApiException catch (e) {
      sessionsErrorMessage.value = e.message;
    } catch (e) {
      sessionsErrorMessage.value =
          'Gagal memuat riwayat percakapan: ${e.toString()}';
    } finally {
      isLoadingSessions.value = false;
    }
  }

  /// Start a new chat session with AI
  Future<void> startNewChat() async {
    if (activeClassroomId.value == null) {
      await initChatbotData();
      if (activeClassroomId.value == null) {
        Get.snackbar('Perhatian', 'Kelas aktif belum ditemukan.');
        return;
      }
    }

    try {
      isSendingMessage.value = true;
      sendErrorMessage.value = '';

      final newSession = await repository.createSession(
        classroomId: activeClassroomId.value!,
      );

      currentSessionId.value = newSession.id;
      messages.clear();
      suggestedQuestions.clear();
      citations.clear();
      isChatActive.value = true;

      // Welcome AI message
      messages.add(
        ChatMessageResponse(
          id: 0,
          role: 'assistant',
          content:
              'Halo! 👋 Aku Clarifier, asisten belajar modulmu di NovaSight AI. Ada bagian modul yang belum jelas atau materi yang ingin kamu tanyakan? Tanyakan langsung ya!',
          createdAt: DateTime.now(),
        ),
      );
    } on ApiException catch (e) {
      Get.snackbar('Gagal Memulai Sesi', e.message);
    } catch (e) {
      Get.snackbar(
        'Gagal Memulai Sesi',
        'Terjadi kesalahan: ${e.toString()}',
      );
    } finally {
      isSendingMessage.value = false;
    }
  }

  /// Open an existing chat session from history
  Future<void> openSession(int sessionId) async {
    currentSessionId.value = sessionId;
    isChatActive.value = true;
    suggestedQuestions.clear();
    citations.clear();
    await loadMessages(sessionId);
  }

  /// Load messages in a specific session
  Future<void> loadMessages(int sessionId) async {
    try {
      isLoadingMessages.value = true;
      messagesErrorMessage.value = '';

      final result = await repository.getMessages(sessionId: sessionId);
      messages.value = result;
      _scrollToBottom();
    } on ApiException catch (e) {
      messagesErrorMessage.value = e.message;
    } catch (e) {
      messagesErrorMessage.value =
          'Gagal memuat pesan percakapan: ${e.toString()}';
    } finally {
      isLoadingMessages.value = false;
    }
  }

  /// Return back to chat history list
  void backToHistory() {
    isChatActive.value = false;
    loadSessions();
  }

  /// Send question to chatbot
  Future<void> sendMessage({String? customText}) async {
    final textToSend = (customText ?? textController.text).trim();
    if (textToSend.isEmpty) return;

    if (customText == null) {
      textController.clear();
    }

    if (currentSessionId.value == null) {
      await startNewChat();
      if (currentSessionId.value == null) return;
    }

    // Optimistically add user message
    final userMsg = ChatMessageResponse(
      id: DateTime.now().millisecondsSinceEpoch,
      role: 'user',
      content: textToSend,
      createdAt: DateTime.now(),
    );
    messages.add(userMsg);
    _scrollToBottom();

    try {
      isSendingMessage.value = true;
      sendErrorMessage.value = '';

      final answer = await repository.askQuestion(
        sessionId: currentSessionId.value!,
        question: textToSend,
      );

      final aiMsg = ChatMessageResponse(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        role: 'assistant',
        content: answer.message,
        citations: answer.sources,
        createdAt: DateTime.now(),
      );
      messages.add(aiMsg);

      if (answer.sources != null && answer.sources!.isNotEmpty) {
        citations.value = answer.sources!;
      }
      if (answer.suggestedQuestions != null &&
          answer.suggestedQuestions!.isNotEmpty) {
        suggestedQuestions.value = answer.suggestedQuestions!;
      } else {
        suggestedQuestions.clear();
      }

      _scrollToBottom();
    } on ApiException catch (e) {
      sendErrorMessage.value = e.message;
      Get.snackbar('Gagal Mengirim Pesan', e.message);
    } catch (e) {
      sendErrorMessage.value = e.toString();
      Get.snackbar(
        'Gagal Mengirim Pesan',
        'Terjadi kesalahan saat memproses jawaban AI.',
      );
    } finally {
      isSendingMessage.value = false;
    }
  }

  /// Handle tap on a suggested follow-up question
  void askSuggestedQuestion(String question) {
    sendMessage(customText: question);
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
