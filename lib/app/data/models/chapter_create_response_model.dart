/// DTO model for ChapterCreateResponse (POST /api/chapters).
class ChapterCreateResponseModel {
  final int chapterId;
  final int jobId;
  final String status;

  ChapterCreateResponseModel({
    required this.chapterId,
    required this.jobId,
    required this.status,
  });

  factory ChapterCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return ChapterCreateResponseModel(
      chapterId: json['chapter_id'] as int? ?? json['id'] as int? ?? 0,
      jobId: json['job_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'chapter_id': chapterId,
        'job_id': jobId,
        'status': status,
      };

  @override
  String toString() =>
      'ChapterCreateResponseModel(chapterId: $chapterId, jobId: $jobId, status: $status)';
}
