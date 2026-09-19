class RegenerateRequestModel {
  final String feedback;
  final List<int> blockIds;

  RegenerateRequestModel({
    required this.feedback,
    required this.blockIds,
  });

  Map<String, dynamic> toJson() => {
        'feedback': feedback,
        'block_ids': blockIds,
      };
}

class RegenerateDetailResponseModel {
  final int blockId;
  final String readableText;

  RegenerateDetailResponseModel({
    required this.blockId,
    required this.readableText,
  });

  factory RegenerateDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return RegenerateDetailResponseModel(
      blockId: json['block_id'] as int? ?? 0,
      readableText: json['readable_text'] as String? ?? '',
    );
  }
}

class RegenerateResponseModel {
  final List<int> blockIds;
  final String readableText;

  RegenerateResponseModel({
    required this.blockIds,
    required this.readableText,
  });

  factory RegenerateResponseModel.fromJson(Map<String, dynamic> json) {
    return RegenerateResponseModel(
      blockIds: (json['block_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      readableText: json['readable_text'] as String? ?? '',
    );
  }
}
