import 'package:etiqa_demo/core/routes.dart';
import 'package:etiqa_demo/database/todo_db.dart';
import 'package:etiqa_demo/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The controller for the `SplashPage` widget.
class SplashPageController extends GetxController {
  @override
  onInit() {
    super.onInit();
    initHive();
  }

  /// Operation run in SplashPage before go to LandingPage
  /// For example, initialize Hive database
  /// after operation done, call countdown and move to next page
  initHive() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TodoItemAdapter(), override: true);
      }
      TodoBox box = TodoBox(hive: Hive);
      Box articlesBox = await box.openTodoBox();
      if (articlesBox.isOpen) {
        countDown();
      }
    } catch (e) {
      showLog('initHive $e');
    }
  }

  /// Countdown 2 seconds before move to next page
  countDown() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAndToNamed(Routes.landing);
    });
  }
}
