import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/user_roles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _passwordKey = "passwordKey";
  static const String _accessTokenKey = "accessTokenKey";
  static const String _userRoleKey = "roleKey";
  static const String _nameKey = "nameKey";
  static const String _emailKey = "emailKey";
  static const String _classCodeKey = "classCodeKey";
  static const String _classNameKey = "classNameKey";
  static const String _languageCodeKey = "languageCodeKey";
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions()
  );
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> writeClassCode(String value) async {
    await _prefs.setString(_classCodeKey, value);
  }

  String? getClassCode() {
    return _prefs.getString(_classCodeKey);
  }

  Future<void> writeClassName(String value) async {
    await _prefs.setString(_classNameKey, value);
  }

  String? getClassName() {
    return _prefs.getString(_classNameKey);
  }

  Future<void> writeUserName(String value) async {
    await _prefs.setString(_nameKey, value);
  }

  String? getUserName() {
    return _prefs.getString(_nameKey);
  }

  Future<void> writeUserEmail(String value) async {
    await _prefs.setString(_emailKey, value);
  }

  String? getUserEmail() {
    return _prefs.getString(_emailKey);
  }

  Future<void> writeUserRole(UserRoles value) async {
    await _prefs.setString(_userRoleKey, value.name);
  }

  UserRoles? getRole() {
    final value = _prefs.getString(_userRoleKey);
    return UserRoles.values.firstWhereOrNull((e) => e.name == value);
  }

  Future<void> writePassword(String value) async {
    await _storage.write(key: _passwordKey, value: value);
  }

  Future<void> writeLanguageCode(String value) async {
    await _prefs.setString(_languageCodeKey, value);
  }

  String? getLanguageCode() {
    return _prefs.getString(_languageCodeKey);
  }

  Future<String?> getPassword() async {
    return _storage.read(key: _passwordKey);
  }

  Future<void> writeAccessToken(String value) async {
    await _storage.write(key: _accessTokenKey, value: value);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
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
    await _storage.delete(key: _accessTokenKey);
  }

  Future<void> clearPassword() async {
    await _storage.delete(key: _passwordKey);
  }
}