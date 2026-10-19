import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/di.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/theme.dart';
import 'package:novasight_app/app/modules/profile/controllers/profile_controller.dart';

import 'app/modules/accessbility/controllers/accessibility_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDepedencies();

  Get.put(
    AccessibilityController(),
    permanent: true,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.primary,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark,
    )
  );
  runApp(
    GetMaterialApp(
      // showSemanticsDebugger:true,
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      theme: MainTheme.lightTheme,
      darkTheme: MainTheme.lightTheme,
      getPages: AppPages.routes,
      supportedLocales: const [
        Locale('id', 'ID'), // Indonesian
        Locale('en', 'US'), // English backup
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('id','ID'),
      builder: (context, child) {
        final systemScale = MediaQuery.textScalerOf(context).scale(1.0);
        return Obx((){
          final appScale = Get.find<AccessibilityController>().textScale.value;
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                    systemScale * appScale
                )
              ),
              child: child ?? const SizedBox.shrink()
          );
        });
      },
    ),
  );
}
