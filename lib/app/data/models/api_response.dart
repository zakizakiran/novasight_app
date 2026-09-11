class ApiResponse<T> {
  final String message;
  final T data;

  ApiResponse({
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      message: json['message'] as String? ?? '',
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T value) toJsonT) {
    return {
      'message': message,
      'data': toJsonT(data),
    };
  }
}
