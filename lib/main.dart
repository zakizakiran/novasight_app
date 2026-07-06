import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/core/di.dart';
import 'package:novasight_app/app/core/styles/theme.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDepedencies();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      theme: MainTheme.lightTheme,
      darkTheme: MainTheme.lightTheme,
      getPages: AppPages.routes,
    ),
  );
}
