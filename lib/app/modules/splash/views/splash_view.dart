import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'SplashView is working',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
                onPressed: () {Get.toNamed(Routes.LOGIN);
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
