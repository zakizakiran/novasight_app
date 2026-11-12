import 'dart:async';

import 'package:get/get.dart';

import 'chapter_job_stream_model.dart';

class JobResponse {
  final int id;
  final int chapterId;
  final RxString pdfPath;
  final Rx<JobStatus> status;
  final String? error;
  final int? blockTotal;
  final RxDouble progress; // 0.0 to 100.0
  final RxBool isReviewed;
  StreamSubscription<ChapterJobStreamEvent>? subscription;

  JobResponse({
    required this.id,
    required this.chapterId,
    required this.pdfPath,
    required this.status,
    this.error,
    this.blockTotal,
    double initialProgress = 0.0,
    bool isReviewed = false,
  }) : progress = initialProgress.obs,
        isReviewed = isReviewed.obs;

  factory JobResponse.fromJson(Map<String, dynamic> json){
    return JobResponse(
        id: json['id'],
        chapterId: json['chapter_id'],
        pdfPath: RxString(json['pdf_path'] as String? ?? ''),
        status: Rx(JobStatus.fromString(json['status'] as String?)),
        error: json['error'],
        blockTotal: json['block_total']
    );
  }

  bool get isDone =>
      status.value.name.toLowerCase() == 'done' ||
          status.value.name.toLowerCase() == 'completed' ||
          progress.value >= 100.0;

  bool get isFailed =>
      status.value.name.toLowerCase() == 'failed' ||
          status.value.name.toLowerCase() == 'error';

  bool get isInProgress => !isDone && !isFailed;

  void dispose() {
    subscription?.cancel();
  }
}

enum JobStatus{
  queued('queued'),
  running('running'),
  retrying('retrying'),
  failed('failed'),
  done('done');

  final String name;
  const JobStatus(this.name);

  factory JobStatus.fromString(String? value) {
    return JobStatus.values.firstWhere(
          (e) => e.name == value,
      orElse: () => JobStatus.queued,
    );
  }
}
