import 'package:lydera_app/app/data/models/chatbot_model.dart';
import 'package:lydera_app/app/data/providers/chatbot_provider.dart';

class ChatbotRepository {
  final ChatbotProvider chatbotProvider;

  ChatbotRepository({required this.chatbotProvider});

  /// Create a new chatbot session for a classroom
  Future<ChatSessionResponse> createSession({
    required int classroomId,
  }) async {
    final response = await chatbotProvider.createSession(
      ChatSessionCreate(classroomId: classroomId),
    );
    return response.data;
  }

  /// Get all chat sessions in a classroom
  Future<List<ChatSessionResponseWithMessage>> getSessions({
    required int classroomId,
  }) async {
    final response = await chatbotProvider.getSessions(
      classroomId: classroomId,
    );
    return response.data;
  }

  /// Ask a question to chatbot in a session
  Future<ChatAnswerResponse> askQuestion({
    required int sessionId,
    required String question,
  }) async {
    final response = await chatbotProvider.askQuestion(
      sessionId: sessionId,
      request: ChatAskRequest(question: question),
    );
    return response.data;
  }

  /// Get all messages in a session
  Future<List<ChatMessageResponse>> getMessages({
    required int sessionId,
  }) async {
    final response = await chatbotProvider.getMessages(
      sessionId: sessionId,
    );
    return response.data;
  }

  /// Teacher reindexes a chapter
  Future<dynamic> reindexChapter({
    required int chapterId,
  }) async {
    final response = await chatbotProvider.reindexChapter(chapterId);
    return response.data;
  }

  /// Teacher reindexes all chapters in a classroom
  Future<dynamic> reindexClassroom({
    required int classroomId,
  }) async {
    final response = await chatbotProvider.reindexClassroom(classroomId);
    return response.data;
  }
}
