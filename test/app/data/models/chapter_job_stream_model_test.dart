import 'package:flutter_test/flutter_test.dart';
import 'package:lydera_app/app/data/models/chapter_job_stream_model.dart';

void main() {
  group('ChapterJobStreamEvent Tests', () {
    test('fromJson parses running event with percentage 0-100', () {
      final json = {
        'job_id': '09f9ed63',
        'status': 'running',
        'progress': 50,
        'message': 'Processing batch 1',
      };

      final event = ChapterJobStreamEvent.fromJson(json);

      expect(event.jobId, equals('09f9ed63'));
      expect(event.status, equals('running'));
      expect(event.progress, equals(50.0));
      expect(event.message, equals('Processing batch 1'));
      expect(event.isDone, isFalse);
      expect(event.isFailed, isFalse);
    });

    test('fromJson normalizes ratio progress (0.65) to 65.0', () {
      final json = {
        'job_id': 12,
        'status': 'running',
        'progress': 0.65,
        'message': 'Annotating content',
      };

      final event = ChapterJobStreamEvent.fromJson(json);

      expect(event.jobId, equals(12));
      expect(event.progress, closeTo(65.0, 0.01));
      expect(event.isDone, isFalse);
    });

    test('fromJson detects done status and annotation_path', () {
      final json = {
        'job_id': 12,
        'status': 'done',
        'progress': 100,
        'message': 'Completed',
        'annotation_path': '16/raw-16/auto/annotated.json',
      };

      final event = ChapterJobStreamEvent.fromJson(json);

      expect(event.status, equals('done'));
      expect(event.isDone, isTrue);
      expect(event.annotationPath, equals('16/raw-16/auto/annotated.json'));
    });

    test('toJson produces correct map', () {
      final event = ChapterJobStreamEvent(
        jobId: 99,
        status: 'completed',
        progress: 100.0,
        message: 'All done',
        annotationPath: 'path/to/annotated.json',
      );

      final map = event.toJson();
      expect(map['job_id'], equals(99));
      expect(map['status'], equals('completed'));
      expect(map['progress'], equals(100.0));
      expect(map['annotation_path'], equals('path/to/annotated.json'));
    });
  });

  group('BlockPreviewResponseModel Tests', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        'reading_order': 1,
        'block_type': 'text',
        'readable_text': 'Pengenalan Logaritma',
        'review_priority': 'normal',
        'heading_level': 2,
        'source_markup': '# Pengenalan',
        'caption': null,
        'image_file': null,
        'page': 1,
      };

      final model = BlockPreviewResponseModel.fromJson(json);

      expect(model.readingOrder, equals(1));
      expect(model.blockType, equals('text'));
      expect(model.readableText, equals('Pengenalan Logaritma'));
      expect(model.reviewPriority, equals('normal'));
      expect(model.headingLevel, equals(2));
      expect(model.page, equals(1));

      final outputMap = model.toJson();
      expect(outputMap['readable_text'], equals('Pengenalan Logaritma'));
      expect(outputMap['reading_order'], equals(1));
    });

    test('fromJson and toJson parse image_url properly for picture blocks', () {
      final json = {
        'reading_order': 2,
        'block_type': 'picture',
        'readable_text': 'Diagram Venn',
        'review_priority': 'normal',
        'heading_level': null,
        'source_markup': null,
        'caption': 'Gambar 1.1 Diagram Venn',
        'image_file': '16/raw-16/auto/images/image_1.png',
        'image_url': 'http://72.61.215.214:8003/static/images/image_1.png',
        'page': 2,
      };

      final model = BlockPreviewResponseModel.fromJson(json);

      expect(model.readingOrder, equals(2));
      expect(model.blockType, equals('picture'));
      expect(model.imageFile, equals('16/raw-16/auto/images/image_1.png'));
      expect(model.imageUrl, equals('http://72.61.215.214:8003/static/images/image_1.png'));
      expect(model.caption, equals('Gambar 1.1 Diagram Venn'));

      final map = model.toJson();
      expect(map['image_url'], equals('http://72.61.215.214:8003/static/images/image_1.png'));
    });
  });
}
