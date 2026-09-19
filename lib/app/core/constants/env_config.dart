class EnvConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://72.61.215.214:8003',
  );

  static const int connectTimeout = 60000; // 15 seconds
  static const int receiveTimeout = 60000; // 15 seconds
}
