import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/chatbot_model.dart';
import 'package:novasight_app/app/data/providers/chatbot_provider.dart';
import 'package:novasight_app/app/data/repositories/chatbot_repository.dart';

class MockChatbotProvider extends Mock implements ChatbotProvider {}

class FakeChatSessionCreate extends Fake implements ChatSessionCreate {}

class FakeChatAskRequest extends Fake implements ChatAskRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChatSessionCreate());
    registerFallbackValue(FakeChatAskRequest());
  });

  late MockChatbotProvider mockProvider;
  late ChatbotRepository repository;

  setUp(() {
    mockProvider = MockChatbotProvider();
    repository = ChatbotRepository(chatbotProvider: mockProvider);
  });

  group('ChatbotRepository Tests', () {
    test('createSession calls provider and returns ChatSessionResponse', () async {
      final mockData = ChatSessionResponse(id: 1, classroomId: 10);
      when(() => mockProvider.createSession(any())).thenAnswer(
        (_) async => ApiResponse(message: 'Success', data: mockData),
      );

      final result = await repository.createSession(classroomId: 10);

      expect(result.id, equals(1));
      expect(result.classroomId, equals(10));
      verify(() => mockProvider.createSession(any())).called(1);
    });

    test('getSessions calls provider and returns List<ChatSessionResponseWithMessage>', () async {
      final mockList = [
        ChatSessionResponseWithMessage(id: 1, classroomId: 10, firstMessage: 'Pertanyaan pertama'),
      ];
      when(() => mockProvider.getSessions(classroomId: 10)).thenAnswer(
        (_) async => ApiResponse(message: 'Success', data: mockList),
      );

      final result = await repository.getSessions(classroomId: 10);

      expect(result.length, equals(1));
      expect(result.first.firstMessage, equals('Pertanyaan pertama'));
      verify(() => mockProvider.getSessions(classroomId: 10)).called(1);
    });

    test('askQuestion calls provider and returns ChatAnswerResponse', () async {
      final mockAnswer = ChatAnswerResponse(
        status: 'success',
        message: 'Jawaban dari AI',
        scopeKlass: 'Kelas 10',
      );
      when(() => mockProvider.askQuestion(sessionId: any(named: 'sessionId'), request: any(named: 'request'))).thenAnswer(
        (_) async => ApiResponse(message: 'Success', data: mockAnswer),
      );

      final result = await repository.askQuestion(sessionId: 1, question: 'Tanya rumus');

      expect(result.status, equals('success'));
      expect(result.message, equals('Jawaban dari AI'));
      verify(() => mockProvider.askQuestion(sessionId: 1, request: any(named: 'request'))).called(1);
    });

    test('getMessages calls provider and returns List<ChatMessageResponse>', () async {
      final mockMessages = [
        ChatMessageResponse(id: 1, role: 'user', content: 'Halo', createdAt: DateTime.now()),
      ];
      when(() => mockProvider.getMessages(sessionId: 1)).thenAnswer(
        (_) async => ApiResponse(message: 'Success', data: mockMessages),
      );

      final result = await repository.getMessages(sessionId: 1);

      expect(result.length, equals(1));
      expect(result.first.role, equals('user'));
      verify(() => mockProvider.getMessages(sessionId: 1)).called(1);
    });

    test('reindexChapter calls provider and returns response data', () async {
      when(() => mockProvider.reindexChapter(5)).thenAnswer(
        (_) async => ApiResponse(message: 'Accepted', data: true),
      );

      final result = await repository.reindexChapter(chapterId: 5);

      expect(result, isTrue);
      verify(() => mockProvider.reindexChapter(5)).called(1);
    });

    test('reindexClassroom calls provider and returns response data', () async {
      when(() => mockProvider.reindexClassroom(10)).thenAnswer(
        (_) async => ApiResponse(message: 'Accepted', data: true),
      );

      final result = await repository.reindexClassroom(classroomId: 10);

      expect(result, isTrue);
      verify(() => mockProvider.reindexClassroom(10)).called(1);
    });
  });
}
