import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class StorageService {
  static const String _PASSWORD_KEY = "passwordKey";
  static const String _ACCESS_TOKEN_KEY = "accessTokenKey";
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions()
  );

  Future<void> writePassword(String value) async {
    await _storage.write(key: _PASSWORD_KEY, value: value);
  }

  Future<String?> getPassword() async {
    return _storage.read(key: _PASSWORD_KEY);
  }

  Future<void> writeAccessToken(String value) async {
    await _storage.write(key: _ACCESS_TOKEN_KEY, value: value);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _ACCESS_TOKEN_KEY);
  }

  Future<void> clearAll() async{
    await _storage.deleteAll();
  }

  Future<void> clearAccessToken() async {
    await _storage.delete(key: _ACCESS_TOKEN_KEY);
  }

  Future<void> clearPassword() async {
    await _storage.delete(key: _PASSWORD_KEY);
  }
}