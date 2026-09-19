// DTO models for Chatbot API endpoints.
// Maps strictly to FastAPI contract:
// - SourceCitation
// - ChatSessionCreate
// - ChatSessionResponse
// - ChatSessionResponseWithMessage
// - ChatAskRequest
// - ChatAnswerResponse
// - ChatMessageResponse

class SourceCitation {
  final String sourceType;
  final String label;
  final String reference;
  final int? trustTier;
  final String evidence;
  final String justification;
  final bool verified;

  SourceCitation({
    required this.sourceType,
    required this.label,
    required this.reference,
    this.trustTier,
    required this.evidence,
    required this.justification,
    this.verified = false,
  });

  factory SourceCitation.fromJson(Map<String, dynamic> json) {
    return SourceCitation(
      sourceType: json['source_type'] as String? ?? '',
      label: json['label'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      trustTier: json['trust_tier'] as int?,
      evidence: json['evidence'] as String? ?? '',
      justification: json['justification'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_type': sourceType,
      'label': label,
      'reference': reference,
      if (trustTier != null) 'trust_tier': trustTier,
      'evidence': evidence,
      'justification': justification,
      'verified': verified,
    };
  }
}

class ChatSessionCreate {
  final int classroomId;

  ChatSessionCreate({required this.classroomId});

  factory ChatSessionCreate.fromJson(Map<String, dynamic> json) {
    return ChatSessionCreate(
      classroomId: json['classroom_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classroom_id': classroomId,
    };
  }
}

class ChatSessionResponse {
  final int id;
  final int classroomId;

  ChatSessionResponse({
    required this.id,
    required this.classroomId,
  });

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      id: json['id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classroom_id': classroomId,
    };
  }
}

class ChatSessionResponseWithMessage {
  final int id;
  final int classroomId;
  final String firstMessage;

  ChatSessionResponseWithMessage({
    required this.id,
    required this.classroomId,
    required this.firstMessage,
  });

  factory ChatSessionResponseWithMessage.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponseWithMessage(
      id: json['id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
      firstMessage: json['first_message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classroom_id': classroomId,
      'first_message': firstMessage,
    };
  }
}

class ChatAskRequest {
  final String question;

  ChatAskRequest({required this.question});

  factory ChatAskRequest.fromJson(Map<String, dynamic> json) {
    return ChatAskRequest(
      question: json['question'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
    };
  }
}

class ChatAnswerResponse {
  final String status;
  final String message;
  final List<SourceCitation>? sources;
  final List<String>? suggestedQuestions;
  final String scopeKlass;

  ChatAnswerResponse({
    required this.status,
    required this.message,
    this.sources,
    this.suggestedQuestions,
    required this.scopeKlass,
  });

  factory ChatAnswerResponse.fromJson(Map<String, dynamic> json) {
    return ChatAnswerResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      sources: json['sources'] != null
          ? (json['sources'] as List)
              .map((e) => SourceCitation.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      suggestedQuestions: json['suggested_questions'] != null
          ? (json['suggested_questions'] as List)
              .map((e) => e.toString())
              .toList()
          : null,
      scopeKlass: json['scope_klass'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (sources != null) 'sources': sources!.map((e) => e.toJson()).toList(),
      if (suggestedQuestions != null) 'suggested_questions': suggestedQuestions,
      'scope_klass': scopeKlass,
    };
  }
}

class ChatMessageResponse {
  final int id;
  final String role;
  final String content;
  final List<SourceCitation>? citations;
  final DateTime createdAt;

  ChatMessageResponse({
    required this.id,
    required this.role,
    required this.content,
    this.citations,
    required this.createdAt,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      id: json['id'] as int? ?? 0,
      role: json['role'] as String? ?? 'user',
      content: json['content'] as String? ?? '',
      citations: json['citations'] != null
          ? (json['citations'] as List)
              .map((e) => SourceCitation.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      if (citations != null)
        'citations': citations!.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
