import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/core/di.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/theme.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDepedencies();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.primary,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark,
    )
  );
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
