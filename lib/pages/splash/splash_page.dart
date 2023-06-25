import 'package:etiqa_demo/core/app_image.dart';
import 'package:etiqa_demo/pages/splash/splash_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A widget which is displayed as the splash screen of the application
class SplashPage extends GetView<SplashPageController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(
          AppImage.splashImage,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
