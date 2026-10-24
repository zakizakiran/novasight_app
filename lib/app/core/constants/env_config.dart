class EnvConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    // defaultValue: 'http://127.0.0.1:8000',
    defaultValue: 'https://lydera.my.id',
  );

  static const int connectTimeout = 60000; // 15 seconds
  static const int receiveTimeout = 60000; // 15 seconds
}
