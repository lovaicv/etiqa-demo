import 'dart:io';

import 'package:etiqa_demo/main.dart';
import 'package:etiqa_demo/pages/landing_new_edit/landing_page.dart';
import 'package:etiqa_demo/pages/landing_new_edit/landing_page_controller.dart';
import 'package:etiqa_demo/pages/new_edit/new_edit_page.dart';
import 'package:etiqa_demo/pages/new_edit/new_edit_page_controller.dart';
import 'package:etiqa_demo/pages/splash/splash_page.dart';
import 'package:etiqa_demo/pages/splash/splash_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late MockHiveInterface mockHiveInterface;
  late MockBox mockBox;
  late SplashPageController splashPageController;
  // late LandingPageController landingPageController;

  setUpAll(() => HttpOverrides.global = null);

  setUp(() async {
    mockHiveInterface = MockHiveInterface();
    mockBox = MockBox();
    splashPageController = SplashPageController();
    // landingPageController = LandingPageController(
    //   hive: mockHiveInterface,
    // );
  });

  testWidgets('Splash Page widget and navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.values).thenReturn(<dynamic>[]);
    tester.view.physicalSize = const Size(800, 600); // set as phone screen size

    Get.put(LandingPageController(hive: mockHiveInterface));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.image(const AssetImage('assets/images/splash.png')), findsOneWidget);
    // if you used scale on AssetImage, use the method below
    // expect(find.image(const ExactAssetImage('assets/images/splash.png', scale: 0.5)), findsOneWidget);

    await splashPageController.countDown();

    await tester.runAsync(() async {
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(LandingPage), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  testWidgets('Landing Page widget and navigation test', (WidgetTester tester) async {
    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.values).thenReturn(<dynamic>[]);

    Get.put(LandingPageController(hive: mockHiveInterface));
    await tester.pumpWidget(GetMaterialApp(
      home: const LandingPage(),
      getPages: [
        GetPage(name: '/landing', page: () => const LandingPage()),
        GetPage(name: '/edit', page: () => const NewEditPage()),
      ],
    ));

    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(NewEditPage), findsOneWidget);
  });

  testWidgets('New Edit Page widget and navigation test', (WidgetTester tester) async {
    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.values).thenReturn(<dynamic>[]);

    Get.put(NewEditPageController(hive: mockHiveInterface));
    NewEditPageController controller = Get.find();
    await tester.pumpWidget(GetMaterialApp(
      home: const LandingPage(),
      getPages: [
        GetPage(name: '/landing', page: () => const LandingPage()),
        GetPage(name: '/edit', page: () => const NewEditPage()),
      ],
    ));

    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(NewEditPage), findsOneWidget);

    expect(find.widgetWithText(AppBar, 'Add new To-Do Item'), findsOneWidget);
    expect(find.text('To Do Title'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Start Date'), findsOneWidget);
    expect(find.text('Estimated End Date'), findsOneWidget);

    expect(controller.isCreate, true);
    expect(find.text('Create New'), findsOneWidget);

    // expect(find.text('Add new To-Do Item'), findsOneWidget); // Check the title text

    // Enter empty title and verify the error message
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Create New'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter some text'), findsOneWidget);

    // Enter a non-empty title and verify the error message disappears
    await tester.enterText(find.byType(TextField), 'Some title');
    await tester.pump();
    expect(find.text('Please enter some text'), findsNothing);

    // Tap on the Start Date field and verify the date picker dialog appears
    await tester.tap(find.text('Start Date'));
    await tester.pumpAndSettle();
    // The date picker logic is triggered when tapped, but since the actual dialog is not a widget in the widget tree,
    // you can verify the expected behavior or state changes in the controller
    expect(controller.startDate.value, isNotNull); // Verify that the start date has been set

    // Tap on the Estimated End Date field and verify the date picker dialog appears
    await tester.tap(find.text('Estimated End Date'));
    await tester.pumpAndSettle();
    // Verify the expected behavior or state changes in the controller for the estimated end date as well
    expect(controller.endDate.value, isNotNull); // Verify that the end date has been set
  });
}
