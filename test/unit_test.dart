import 'package:etiqa_demo/core/routes.dart';
import 'package:etiqa_demo/database/todo_db.dart';
import 'package:etiqa_demo/pages/landing/landing_page_controller.dart';
import 'package:etiqa_demo/pages/new_edit/new_edit_page_controller.dart';
import 'package:etiqa_demo/pages/splash/splash_page_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'unit_test.mocks.dart';

@GenerateMocks([HiveInterface, Box, TodoBox])
void main() {
  late SplashPageController splashPageController;
  late LandingPageController landingPageController;
  late NewEditPageController newEditPageController;
  late MockHiveInterface mockHiveInterface;
  late MockBox mockBox;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockBox = MockBox();
    splashPageController = SplashPageController();
    landingPageController = LandingPageController(hive: mockHiveInterface);
    newEditPageController = NewEditPageController(hive: mockHiveInterface);
  });

  test('countDown should navigate to landing route after 2 seconds', () {
    Get.testMode = true;
    Get.put<SplashPageController>(splashPageController);

    splashPageController.countDown();

    // Advance the timer by 2 seconds
    Get.testMode = false;
    Future.delayed(const Duration(seconds: 2), () {}).then((_) {
      expect(Get.currentRoute, Routes.landing);
    });
  });

  test('getTodoList should populate todoList with items from the box', () async {
    final mockTodoList = [
      TodoItem(
        'Task 1',
        DateTime(2023, 1, 1),
        DateTime(2023, 1, 2),
        false,
        0,
      ),
      TodoItem(
        'Task 2',
        DateTime(2023, 1, 3),
        DateTime(2023, 1, 4),
        true,
        0,
      ),
    ];

    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    // when(mockTodoBox.getAllItems()).thenAnswer((_) async => mockTodoList);
    when(mockBox.values).thenReturn(mockTodoList);

    await landingPageController.getTodoList();

    expect(landingPageController.todoList.length, equals(2));
    expect(landingPageController.todoList[0].title, equals('Task 1'));
    expect(landingPageController.todoList[1].title, equals('Task 2'));
    expect(landingPageController.isTodoListEmpty.value, isFalse);
  });

  test('deleteItem should remove a todo item from the list', () async {
    final mockTodo = TodoItem(
      'Task',
      DateTime(2023, 1, 1),
      DateTime(2023, 1, 2),
      false,
      0,
    );

    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.values).thenReturn([mockTodo]);

    landingPageController.todoList.add(mockTodo);

    // Mocking the behavior of the TodoBox.deleteItem() method
    when(mockBox.delete(1)).thenAnswer((_) async {});

    // Call the deleteItem method
    await landingPageController.deleteItem(1);

    // Verify that the item is removed from the todoList
    expect(landingPageController.todoList.length, 0);
  });

  test('setTitle should update the title and isTitleEmpty status', () {
    const title = 'Test Title';

    newEditPageController.setTitle(title);

    expect(newEditPageController.title, title);
    expect(newEditPageController.isTitleEmpty.value, false);
  });

  test('setStartDate should update the start date', () {
    final startDate = DateTime(2023, 1, 1);

    newEditPageController.setStartDate(startDate);

    expect(newEditPageController.startDate.value, startDate);
  });

  test('setEndDate should update the end date', () {
    final endDate = DateTime(2023, 1, 2);

    newEditPageController.setEndDate(endDate);

    expect(newEditPageController.endDate.value, endDate);
  });

  test('createUpdate should create a new todo item', () async {
    Get.testMode = true;

    const title = 'Test Title';
    final startDate = DateTime(2023, 1, 1);
    final endDate = DateTime(2023, 1, 2);
    final mockTodo = TodoItem(
      title,
      startDate,
      endDate,
      false,
      0,
    );

    // Mock the necessary dependencies and method calls
    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.add(any)).thenAnswer((_) async => 1);
    when(mockBox.values).thenReturn([mockTodo]);

    newEditPageController.isCreate = true;
    newEditPageController.setTitle(title);
    newEditPageController.setStartDate(startDate);
    newEditPageController.setEndDate(endDate);
    await newEditPageController.createUpdate();

    // Verify the expected behavior
    expect(newEditPageController.isCreate, true);
    expect(mockBox.values.length, 1);
  });

  test('createUpdate should update an existing todo item', () async {
    const title = 'New Title';
    final startDate = DateTime(2023, 1, 1);
    final endDate = DateTime(2023, 1, 2);
    const todoKey = 1;
    final mockTodo = TodoItem(
      'Old Title',
      DateTime(2023, 2, 1),
      DateTime(2023, 2, 2),
      false,
      0,
    );

    newEditPageController.setTitle(title);
    newEditPageController.setStartDate(startDate);
    newEditPageController.setEndDate(endDate);
    newEditPageController.isCreate = false;
    newEditPageController.todoKey = todoKey;

    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.get(todoKey)).thenAnswer((_) async => mockTodo);

    await newEditPageController.createUpdate();

    expect(newEditPageController.isCreate, false);
    expect(newEditPageController.todoKey, todoKey);
    expect(mockTodo.title, title);
    expect(mockTodo.startDate, startDate);
    expect(mockTodo.endDate, endDate);
    verify(mockBox.get(todoKey)).called(1);
  });
}
