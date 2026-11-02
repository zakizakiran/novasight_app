import 'package:get/get.dart';
import 'package:lydera_app/app/core/network/database_client.dart';

import '../../../core/network/database.dart';

class DatabaseService extends GetxService {
  late final AppDatabase database;
  late final DatabaseClient client;

  @override
  void onInit() {
    super.onInit();
    database = AppDatabase();
    client = DatabaseClient(database);
  }

  @override
  void onClose() {
    database.close();
    super.onClose();
  }
}