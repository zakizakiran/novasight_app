import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/text_theme.dart';


import 'colors/color_constant.dart';

class MainTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Nunito',
      scaffoldBackgroundColor: ColorConstant.background,
      textSelectionTheme: _textSelectionThemeData.copyWith(
          selectionHandleColor: ColorConstant.black),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: ColorConstant.background,
        suffixIconColor: ColorConstant.black,
        prefixIconColor: ColorConstant.grey,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorConstant.primary,
        brightness: Brightness.light,
        shadow: ColorConstant.shadowColor,
        error: ColorConstant.redColor,
        onError: ColorConstant.redColor,
      ),
      // cardTheme: const CardThemeData(
      //   color: ColorConstant.white
      // ),
      brightness: Brightness.light,
      textTheme: const MainTextTheme(),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorConstant.background,
        toolbarTextStyle: const TextTheme().titleLarge,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
      ),
    );
  }

  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     fontFamily: 'HelveticaNeue',
  //     scaffoldBackgroundColor: ColorConstant.black,
  //     textSelectionTheme: _textSelectionThemeData.copyWith(
  //       selectionHandleColor: ColorConstant.white,
  //     ),
  //     colorScheme: ColorScheme.fromSeed(
  //       seedColor: ColorConstant.darkPrimaryBlue,
  //       brightness: Brightness.dark,
  //       error: ColorConstant.red,
  //       shadow: ColorConstant.shadowColorDark,
  //       onError: ColorConstant.red,
  //     ),
  //     inputDecorationTheme: const InputDecorationTheme(
  //       fillColor: ColorConstant.darkTextField,
  //     ),
  //     cardTheme: const CardTheme(color: ColorConstant.darkGrey),
  //     brightness: Brightness.dark,
  //     textTheme: const MainTextTheme(),
  //     useMaterial3: true,
  //     appBarTheme: AppBarTheme(
  //       color: ColorConstant.charcoalGrey,
  //       toolbarTextStyle: const TextTheme().titleLarge,
  //       shape: const BeveledRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           bottomRight: Radius.circular(14),
  //           bottomLeft: Radius.circular(14),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static TextSelectionThemeData get _textSelectionThemeData {
    return const TextSelectionThemeData(
      selectionColor: ColorConstant.grey,
      selectionHandleColor: ColorConstant.black,
    );
  }

  // static TextTheme get _textTheme {
  //   return TextTheme(
  //     displayLarge: CustomTextStyles.displayLarge,
  //     displayMedium: CustomTextStyles.displayMedium,
  //     displaySmall: CustomTextStyles.displaySmall,
  //     titleLarge: CustomTextStyles.titleLarge,
  //     titleMedium: CustomTextStyles.titleMedium,
  //     titleSmall: CustomTextStyles.titleSmall,
  //     headlineLarge: CustomTextStyles.headlineLarge,
  //     headlineMedium: CustomTextStyles.headlineMedium,
  //     headlineSmall: CustomTextStyles.headlineSmall,
  //     labelLarge: CustomTextStyles.labelLarge,
  //     labelMedium: CustomTextStyles.labelMedium,
  //     labelSmall: CustomTextStyles.labelSmall,
  //     bodyLarge: CustomTextStyles.bodyLargeBold,
  //     bodyMedium: CustomTextStyles.bodyLargeMedium,
  //     bodySmall: CustomTextStyles.bodyLargeRegular,
  //   );
  // }
}
