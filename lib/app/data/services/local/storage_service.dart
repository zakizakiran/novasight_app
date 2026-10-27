import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/user_roles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _PASSWORD_KEY = "passwordKey";
  static const String _ACCESS_TOKEN_KEY = "accessTokenKey";
  static const String _USER_ROLE_KEY = "roleKey";
  static const String _NAME_KEY = "nameKey";
  static const String _EMAIL_KEY = "emailKey";
  static const String _CLASS_CODE_KEY = "classCodeKey";
  static const String _CLASS_NAME_KEY = "classNameKey";
  static const String _LANGUAGE_CODE_KEY = "languageCodeKey";
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions()
  );
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> writeClassCode(String value) async {
    await _prefs.setString(_CLASS_CODE_KEY, value);
  }

  String? getClassCode() {
    return _prefs.getString(_CLASS_CODE_KEY);
  }

  Future<void> writeClassName(String value) async {
    await _prefs.setString(_CLASS_NAME_KEY, value);
  }

  String? getClassName() {
    return _prefs.getString(_CLASS_NAME_KEY);
  }

  Future<void> writeUserName(String value) async {
    await _prefs.setString(_NAME_KEY, value);
  }

  String? getUserName() {
    return _prefs.getString(_NAME_KEY);
  }

  Future<void> writeUserEmail(String value) async {
    await _prefs.setString(_EMAIL_KEY, value);
  }

  String? getUserEmail() {
    return _prefs.getString(_EMAIL_KEY);
  }

  Future<void> writeUserRole(UserRoles value) async {
    await _prefs.setString(_USER_ROLE_KEY, value.name);
  }

  UserRoles? getRole() {
    final value = _prefs.getString(_USER_ROLE_KEY);
    return UserRoles.values.firstWhereOrNull((e) => e.name == value);
  }

  Future<void> writePassword(String value) async {
    await _storage.write(key: _PASSWORD_KEY, value: value);
  }

  Future<void> writeLanguageCode(String value) async {
    await _prefs.setString(_LANGUAGE_CODE_KEY, value);
  }

  String? getLanguageCode() {
    return _prefs.getString(_LANGUAGE_CODE_KEY);
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

  Future<void> clearAll() async {
    final savedLang = getLanguageCode();
    await _storage.deleteAll();
    await _prefs.clear();
    if (savedLang != null) {
      await writeLanguageCode(savedLang);
    }
  }

  Future<void> clearAccessToken() async {
    await _storage.delete(key: _ACCESS_TOKEN_KEY);
  }

  Future<void> clearPassword() async {
    await _storage.delete(key: _PASSWORD_KEY);
  }
}