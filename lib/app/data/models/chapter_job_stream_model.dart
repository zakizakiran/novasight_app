/// DTO model for SSE events from GET /api/chapters/jobs/{job_id}/stream
/// and Preview blocks from GET /api/chapters/preview.
library;

class ChapterJobStreamEvent {
  final dynamic jobId;
  final String status;
  final double progress; // Normalized 0.0 - 100.0
  final String message;
  final String? annotationPath;
  final dynamic rawData;

  ChapterJobStreamEvent({
    required this.jobId,
    required this.status,
    required this.progress,
    this.message = '',
    this.annotationPath,
    this.rawData,
  });

  bool get isDone {
    final s = status.toLowerCase();
    return s == 'done' || s == 'completed' || progress >= 100.0;
  }

  bool get isFailed {
    final s = status.toLowerCase();
    return s == 'failed' || s == 'error';
  }

  factory ChapterJobStreamEvent.fromJson(Map<String, dynamic> json) {
    num rawProgress = 0;
    if (json['progress'] != null) {
      rawProgress = json['progress'] as num;
    }

    double prog = rawProgress.toDouble();
    // If progress is given as ratio e.g. 0.65 instead of 65
    if (prog > 0 && prog <= 1.0) {
      prog = prog * 100.0;
    }

    String? annotPath;
    if (json['annotation_path'] != null) {
      annotPath = json['annotation_path'] as String;
    } else if (json['data'] is Map && json['data']['annotation_path'] != null) {
      annotPath = json['data']['annotation_path'] as String;
    }

    return ChapterJobStreamEvent(
      jobId: json['job_id'],
      status: json['status'] as String? ?? 'running',
      progress: prog,
      message: json['message'] as String? ?? '',
      annotationPath: annotPath,
      rawData: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'status': status,
      'progress': progress,
      'message': message,
      if (annotationPath != null) 'annotation_path': annotationPath,
      if (rawData != null) 'data': rawData,
    };
  }
}

class BlockPreviewResponseModel {
  final int readingOrder;
  final String blockType;
  final String readableText;
  final String reviewPriority;
  final int? headingLevel;
  final String? sourceMarkup;
  final String? caption;
  final String? imageFile;
  final String? imageUrl;
  final int? page;

  BlockPreviewResponseModel({
    required this.readingOrder,
    required this.blockType,
    required this.readableText,
    required this.reviewPriority,
    this.headingLevel,
    this.sourceMarkup,
    this.caption,
    this.imageFile,
    this.imageUrl,
    this.page,
  });

  factory BlockPreviewResponseModel.fromJson(Map<String, dynamic> json) {
    return BlockPreviewResponseModel(
      readingOrder: json['reading_order'] as int? ?? 0,
      blockType: json['block_type'] as String? ?? '',
      readableText: json['readable_text'] as String? ?? '',
      reviewPriority: json['review_priority'] as String? ?? '',
      headingLevel: json['heading_level'] as int?,
      sourceMarkup: json['source_markup'] as String?,
      caption: json['caption'] as String?,
      imageFile: json['image_file'] as String?,
      imageUrl: json['image_url'] as String?,
      page: json['page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reading_order': readingOrder,
      'block_type': blockType,
      'readable_text': readableText,
      'review_priority': reviewPriority,
      'heading_level': headingLevel,
      'source_markup': sourceMarkup,
      'caption': caption,
      'image_file': imageFile,
      if (imageUrl != null) 'image_url': imageUrl,
      'page': page,
    };
  }
}
