import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../../core/styles/img/img_constant.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      body: Center(
        child: Image.asset(
          ImgConstant.mobileApp,
          fit: BoxFit.fill,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
