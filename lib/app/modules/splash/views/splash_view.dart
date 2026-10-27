import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/styles/colors/color_constant.dart';
import '../../../core/styles/img/img_constant.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Image.asset(
            ImgConstant.lyderaApp,
            fit: BoxFit.contain,
            width: 240,
            cacheWidth: 480,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.school,
                size: 80,
                color: ColorConstant.primary,
              );
            },
          ),
        ),
      ),
    );
  }
}
