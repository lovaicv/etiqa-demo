import 'package:etiqa_demo/core/routes.dart';
import 'package:etiqa_demo/lang/translation_service.dart';
import 'package:etiqa_demo/pages/landing/landing_page.dart';
import 'package:etiqa_demo/pages/landing/landing_page_controller.dart';
import 'package:etiqa_demo/pages/new_edit/new_edit_page.dart';
import 'package:etiqa_demo/pages/new_edit/new_edit_page_controller.dart';
import 'package:etiqa_demo/pages/splash/splash_page.dart';
import 'package:etiqa_demo/pages/splash/splash_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// The entry point of the application.
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// GetX is used to provide state management, translation, dependency injection, and route management.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      title: 'Etiqa Demo',
      debugShowCheckedModeBanner: false,
      defaultTransition: GetPlatform.isIOS ? Get.defaultTransition : Transition.cupertino,
      initialRoute: Routes.splash,
      initialBinding: BindingsBuilder(() {}),
      getPages: [
        GetPage(
          name: Routes.splash,
          page: () => const SplashPage(),
          binding: BindingsBuilder(() {
            Get.put(SplashPageController());
          }),
        ),
        GetPage(
          name: Routes.landing,
          page: () => const LandingPage(),
          binding: BindingsBuilder(() {
            Get.put(LandingPageController(hive: Hive));
          }),
        ),
        GetPage(
          name: Routes.edit,
          page: () => const NewEditPage(),
          binding: BindingsBuilder(() {
            Get.put(NewEditPageController(hive: Hive));
          }),
        ),
      ],
    );
  }
}
