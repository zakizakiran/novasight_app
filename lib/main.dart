import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/di.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/theme.dart';
import 'package:novasight_app/l10n/app_localizations.dart';

import 'app/modules/accessbility/controllers/accessibility_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDepedencies();

  Get.put(AccessibilityController(), permanent: true);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.primary,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark,
    ),
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
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Get.find<AccessibilityController>().locale.value,
      builder: (context, child) {
        final systemScale = MediaQuery.textScalerOf(context).scale(1.0);
        return Obx(() {
          final appScale = Get.find<AccessibilityController>().textScale.value;
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(systemScale * appScale)),
            child: child ?? const SizedBox.shrink(),
          );
        });
      },
    ),
  );
}
