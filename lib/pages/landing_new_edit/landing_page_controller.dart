import 'package:etiqa_demo/core/app_string.dart';
import 'package:etiqa_demo/core/routes.dart';
import 'package:etiqa_demo/database/todo_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Controller class for the landing page.
class LandingPageController extends GetxController {
  LandingPageController({required this.hive});

  final HiveInterface hive;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  RxList<TodoItem> todoList = <TodoItem>[].obs;
  RxBool isTodoListEmpty = true.obs;
  RxString sortBy = AppString.defaultText.tr.obs;
  List<String> sortByList = [
    AppString.defaultText.tr,
    AppString.title.tr,
    AppString.startDate.tr,
    AppString.endDate.tr,
    AppString.timeLeft.tr,
    AppString.status.tr,
  ];
  RxString orderBy = AppString.ascending.tr.obs;
  List<String> orderByList = [AppString.ascending.tr, AppString.descending.tr];

  // ===========================================================================
  ScrollController scrollController = ScrollController();
  TextEditingController titleController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxInt todoKey = (-1).obs;
  String title = '';
  RxBool isTitleEmpty = false.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxString isStartDateError = ''.obs;
  RxString isEndDateError = ''.obs;
  RxBool isCreate = true.obs;

  @override
  void onInit() {
    getTodoList();
    super.onInit();
  }

  /// Retrieves all todoItem from the database.
  Future<void> getTodoList() async {
    todoList.clear();
    TodoBox box = TodoBox(hive: hive);
    List<TodoItem> rxList = await box.getAllItems();
    todoList.addAll(rxList);
    isTodoListEmpty.value = todoList.isEmpty;
  }

  /// Updates the [isComplete] status of a todoItem by it's [key].
  Future<void> updateItem(int key, bool isComplete) async {
    TodoBox box = TodoBox(hive: hive);
    await box.getItem(key)
      ..isComplete = isComplete
      ..save();
    getTodoList();
  }

  /// Deletes a todoItem by it's [key] from the database.
  Future<void> deleteItem(int key) async {
    TodoBox box = TodoBox(hive: hive);
    await box.deleteItem(key);
    getTodoList();
  }

  /// Sets the sorting option for the todoItem list.
  void setSortBy(String? value) {
    sortBy.value = value ?? AppString.title.tr;
    sorting();
  }

  /// Sets the ordering option for the todoItem list.
  void setOrderBy(String? value) {
    orderBy.value = value ?? AppString.ascending.tr;
    sorting();
  }

  /// Sorts the todoItem list based on the selected sorting and ordering options.
  sorting() {
    bool ascending = orderBy.value == AppString.ascending.tr;

    for (var todo in todoList) {
      Duration duration = todo.endDate.difference(DateTime.now());
      todo.timeLeft = duration.inMilliseconds;
    }

    if (sortBy.value == AppString.defaultText.tr) {
      todoList.sort((a, b) => ascending ? a.key.compareTo(b.key) : b.key.compareTo(a.key));
    } else if (sortBy.value == AppString.title.tr) {
      todoList.sort((a, b) => ascending ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
    } else if (sortBy.value == AppString.startDate.tr) {
      todoList.sort((a, b) => ascending ? a.startDate.compareTo(b.startDate) : b.startDate.compareTo(a.startDate));
    } else if (sortBy.value == AppString.endDate.tr) {
      todoList.sort((a, b) => ascending ? a.endDate.compareTo(b.endDate) : b.endDate.compareTo(a.endDate));
    } else if (sortBy.value == AppString.timeLeft.tr) {
      todoList.sort((a, b) => ascending ? a.timeLeft.compareTo(b.timeLeft) : b.timeLeft.compareTo(a.timeLeft));
    } else if (sortBy.value == AppString.status.tr) {
      todoList.sort((a, b) => ascending ? (a.isComplete ? 1 : -1) : (b.isComplete ? 1 : -1));
    }
  }

  /// Sets up the todoItem by it's [todoKey] for editing.
  setupItem(int todoKey) async {
    isCreate.value = false;
    this.todoKey.value = todoKey;
    TodoBox box = TodoBox(hive: hive);
    TodoItem todoItem = await box.getItem(todoKey);
    titleController.text = todoItem.title;
    startDate.value = todoItem.startDate;
    endDate.value = todoItem.endDate;
  }

  /// Sets the [title] of the todoItem.
  void setTitle(String title) {
    this.title = title;
    isTitleEmpty.value = title.isEmpty;
  }

  /// Sets the start [date] of the todoItem.
  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  /// Sets the end [date] of the todoItem.
  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  /// Creates or updates the todoItem.
  Future<void> createUpdate(bool isCreate) async {
    if (title.isEmpty) {
      isTitleEmpty.value = true;
      return;
    }
    if (startDate.value.isAfter(endDate.value)) {
      isEndDateError.value = AppString.endDateError.tr;
      return;
    } else {
      isEndDateError.value = '';
    }
    TodoBox box = TodoBox(hive: hive);
    if (isCreate) {
      await box.addNewItem(TodoItem(title, startDate.value, endDate.value, false, 0));
      if (Get.currentRoute == Routes.edit) {
        Get.back(result: true);
      } else {
        getTodoList();
      }
    } else {
      TodoItem todoItem = await box.getItem(todoKey.value)
        ..title = title
        ..startDate = startDate.value
        ..endDate = endDate.value;
      await box.updateItem(todoKey.value, todoItem); // this is equal to ..save() but due to unit test save() will have error
      if (Get.currentRoute == Routes.edit) {
        Get.back(result: true);
      } else {
        getTodoList();
      }
    }
  }
}
