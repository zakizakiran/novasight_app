import 'package:flutter_test/flutter_test.dart';
import 'package:novasight_app/app/data/models/chatbot_model.dart';

void main() {
  group('ChatbotModel Tests', () {
    test('SourceCitation fromJson and toJson work correctly', () {
      final json = {
        'source_type': 'module_chapter',
        'label': 'Bab 1 Eksponen',
        'reference': 'Halaman 12',
        'trust_tier': 1,
        'evidence': '2 pangkat 3 adalah 8',
        'justification': 'Sesuai dengan materi bab 1',
        'verified': true,
      };

      final citation = SourceCitation.fromJson(json);
      expect(citation.sourceType, equals('module_chapter'));
      expect(citation.label, equals('Bab 1 Eksponen'));
      expect(citation.reference, equals('Halaman 12'));
      expect(citation.trustTier, equals(1));
      expect(citation.evidence, equals('2 pangkat 3 adalah 8'));
      expect(citation.justification, equals('Sesuai dengan materi bab 1'));
      expect(citation.verified, isTrue);

      final convertedJson = citation.toJson();
      expect(convertedJson['source_type'], equals('module_chapter'));
      expect(convertedJson['label'], equals('Bab 1 Eksponen'));
      expect(convertedJson['trust_tier'], equals(1));
      expect(convertedJson['verified'], isTrue);
    });

    test('ChatSessionCreate fromJson and toJson work correctly', () {
      final json = {'classroom_id': 10};
      final req = ChatSessionCreate.fromJson(json);
      expect(req.classroomId, equals(10));
      expect(req.toJson(), equals(json));
    });

    test('ChatSessionResponse fromJson and toJson work correctly', () {
      final json = {'id': 1, 'classroom_id': 10};
      final res = ChatSessionResponse.fromJson(json);
      expect(res.id, equals(1));
      expect(res.classroomId, equals(10));
      expect(res.toJson(), equals(json));
    });

    test('ChatSessionResponseWithMessage fromJson and toJson work correctly', () {
      final json = {
        'id': 2,
        'classroom_id': 10,
        'first_message': 'Halo apa itu eksponen?',
      };
      final res = ChatSessionResponseWithMessage.fromJson(json);
      expect(res.id, equals(2));
      expect(res.classroomId, equals(10));
      expect(res.firstMessage, equals('Halo apa itu eksponen?'));
      expect(res.toJson(), equals(json));
    });

    test('ChatAskRequest fromJson and toJson work correctly', () {
      final json = {'question': 'Bagaimana rumus pythagoras?'};
      final req = ChatAskRequest.fromJson(json);
      expect(req.question, equals('Bagaimana rumus pythagoras?'));
      expect(req.toJson(), equals(json));
    });

    test('ChatAnswerResponse fromJson and toJson work correctly', () {
      final json = {
        'status': 'success',
        'message': 'Rumus pythagoras adalah a^2 + b^2 = c^2.',
        'sources': [
          {
            'source_type': 'module',
            'label': 'Geometri',
            'reference': 'Bab 3',
            'trust_tier': 1,
            'evidence': 'a^2 + b^2 = c^2',
            'justification': 'Teorema segitiga siku-siku',
            'verified': true,
          }
        ],
        'suggested_questions': [
          'Apa itu tripel pythagoras?',
          'Bagaimana mencari sisi miring?',
        ],
        'scope_klass': 'Kelas 10',
      };

      final ans = ChatAnswerResponse.fromJson(json);
      expect(ans.status, equals('success'));
      expect(ans.message, contains('pythagoras'));
      expect(ans.sources?.length, equals(1));
      expect(ans.sources?.first.label, equals('Geometri'));
      expect(ans.suggestedQuestions?.length, equals(2));
      expect(ans.suggestedQuestions?.first, equals('Apa itu tripel pythagoras?'));
      expect(ans.scopeKlass, equals('Kelas 10'));

      final convertedJson = ans.toJson();
      expect(convertedJson['status'], equals('success'));
      expect(convertedJson['scope_klass'], equals('Kelas 10'));
    });

    test('ChatMessageResponse fromJson and toJson work correctly', () {
      final now = DateTime.parse('2026-09-17T03:00:00.000Z');
      final json = {
        'id': 100,
        'role': 'assistant',
        'content': 'Ini adalah penjelasan lengkap.',
        'citations': null,
        'created_at': now.toIso8601String(),
      };

      final msg = ChatMessageResponse.fromJson(json);
      expect(msg.id, equals(100));
      expect(msg.role, equals('assistant'));
      expect(msg.content, equals('Ini adalah penjelasan lengkap.'));
      expect(msg.citations, isNull);
      expect(msg.createdAt, equals(now));

      final convertedJson = msg.toJson();
      expect(convertedJson['id'], equals(100));
      expect(convertedJson['role'], equals('assistant'));
    });
  });
}
