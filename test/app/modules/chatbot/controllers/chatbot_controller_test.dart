import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/models/chatbot_model.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/repositories/chatbot_repository.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/chatbot/controllers/chatbot_controller.dart';

class MockChatbotRepository extends Mock implements ChatbotRepository {}

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockChatbotRepository mockChatbotRepo;
  late MockClassroomRepository mockClassroomRepo;
  late MockStorageService mockStorage;
  late ChatbotController controller;

  final testNow = DateTime.parse('2026-09-17T03:00:00.000Z');

  final mockClassrooms = [
    ClassroomResponseModel(
      id: 10,
      teacherId: 2,
      schoolId: 1,
      name: 'Kelas 10 Matematika',
      code: 'CLS-1234',
      grade: 10,
      classroomType: ClassroomTypeModel(
        id: 1,
        name: 'Tunanetra',
        createdAt: testNow,
        updatedAt: testNow,
      ),
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  final mockSessions = [
    ChatSessionResponseWithMessage(
      id: 1,
      classroomId: 10,
      firstMessage: 'Apa itu matriks invers?',
    ),
  ];

  setUp(() {
    Get.testMode = true;
    mockChatbotRepo = MockChatbotRepository();
    mockClassroomRepo = MockClassroomRepository();
    mockStorage = MockStorageService();

    when(() => mockStorage.getClassCode()).thenReturn('CLS-1234');
    when(() => mockClassroomRepo.getClassrooms()).thenAnswer((_) async => mockClassrooms);
    when(() => mockChatbotRepo.getSessions(classroomId: 10)).thenAnswer((_) async => mockSessions);

    controller = ChatbotController(
      repository: mockChatbotRepo,
      classroomRepository: mockClassroomRepo,
      storageService: mockStorage,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('ChatbotController Tests', () {
    test('initChatbotData finds classroom and loads sessions', () async {
      await controller.initChatbotData();

      expect(controller.activeClassroomId.value, equals(10));
      expect(controller.sessions.length, equals(1));
      expect(controller.sessions.first.firstMessage, equals('Apa itu matriks invers?'));
      expect(controller.isLoadingSessions.value, isFalse);
      expect(controller.sessionsErrorMessage.value, isEmpty);
    });

    test('startNewChat creates new session and activates chat with welcome message', () async {
      controller.activeClassroomId.value = 10;
      when(() => mockChatbotRepo.createSession(classroomId: 10)).thenAnswer(
        (_) async => ChatSessionResponse(id: 99, classroomId: 10),
      );

      await controller.startNewChat();

      expect(controller.currentSessionId.value, equals(99));
      expect(controller.isChatActive.value, isTrue);
      expect(controller.messages.length, equals(1));
      expect(controller.messages.first.role, equals('assistant'));
      expect(controller.messages.first.content, contains('NovaSight AI'));
    });

    test('openSession sets active session and loads messages', () async {
      final mockMessages = [
        ChatMessageResponse(id: 1, role: 'user', content: 'Halo AI', createdAt: testNow),
        ChatMessageResponse(id: 2, role: 'assistant', content: 'Halo juga!', createdAt: testNow),
      ];
      when(() => mockChatbotRepo.getMessages(sessionId: 1)).thenAnswer((_) async => mockMessages);

      await controller.openSession(1);

      expect(controller.currentSessionId.value, equals(1));
      expect(controller.isChatActive.value, isTrue);
      expect(controller.messages.length, equals(2));
      expect(controller.messages.first.content, equals('Halo AI'));
      expect(controller.messages.last.content, equals('Halo juga!'));
    });

    test('sendMessage sends question, adds messages, and updates suggested questions', () async {
      controller.currentSessionId.value = 1;
      controller.activeClassroomId.value = 10;
      controller.textController.text = 'Apa rumus determinan matriks 2x2?';

      final mockAnswer = ChatAnswerResponse(
        status: 'success',
        message: 'Determinan matriks [[a,b],[c,d]] adalah ad - bc.',
        sources: [
          SourceCitation(
            sourceType: 'chapter',
            label: 'Matriks',
            reference: 'Bab 2',
            evidence: 'ad - bc',
            justification: 'Definisi determinan',
            verified: true,
          ),
        ],
        suggestedQuestions: ['Apa itu matriks singular?'],
        scopeKlass: 'Kelas 10',
      );

      when(() => mockChatbotRepo.askQuestion(sessionId: 1, question: any(named: 'question')))
          .thenAnswer((_) async => mockAnswer);

      await controller.sendMessage();

      expect(controller.messages.length, equals(2));
      expect(controller.messages[0].role, equals('user'));
      expect(controller.messages[0].content, equals('Apa rumus determinan matriks 2x2?'));
      expect(controller.messages[1].role, equals('assistant'));
      expect(controller.messages[1].content, contains('ad - bc'));
      expect(controller.citations.length, equals(1));
      expect(controller.citations.first.label, equals('Matriks'));
      expect(controller.suggestedQuestions.length, equals(1));
      expect(controller.suggestedQuestions.first, equals('Apa itu matriks singular?'));
    });

    test('askSuggestedQuestion invokes sendMessage with question string', () async {
      controller.currentSessionId.value = 1;
      controller.activeClassroomId.value = 10;

      final mockAnswer = ChatAnswerResponse(
        status: 'success',
        message: 'Matriks singular adalah matriks yang determinannya nol.',
        scopeKlass: 'Kelas 10',
      );

      when(() => mockChatbotRepo.askQuestion(sessionId: 1, question: 'Apa itu matriks singular?'))
          .thenAnswer((_) async => mockAnswer);

      controller.askSuggestedQuestion('Apa itu matriks singular?');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.messages.last.role, equals('assistant'));
      expect(controller.messages.last.content, contains('determinannya nol'));
    });

    test('backToHistory exits chat and refreshes sessions', () async {
      controller.isChatActive.value = true;
      controller.activeClassroomId.value = 10;

      controller.backToHistory();

      expect(controller.isChatActive.value, isFalse);
      verify(() => mockChatbotRepo.getSessions(classroomId: 10)).called(1);
    });
  });
}
