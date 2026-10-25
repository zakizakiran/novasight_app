import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const channel =
        MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  test('StorageService clearAll preserves languageCode', () async {
    SharedPreferences.setMockInitialValues({
      'languageCodeKey': 'en',
      'nameKey': 'Budi',
      'emailKey': 'budi@test.com',
    });

    final storage = StorageService();
    await storage.init();

    expect(storage.getLanguageCode(), 'en');
    expect(storage.getUserName(), 'Budi');

    await storage.clearAll();

    expect(storage.getLanguageCode(), 'en');
    expect(storage.getUserName(), isNull);
    expect(storage.getUserEmail(), isNull);
  });
}
