import 'package:etiqa_demo/core/app_string.dart';
import 'package:etiqa_demo/database/todo_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Controller class for the New/Edit page.
class NewEditPageController extends GetxController {
  NewEditPageController({required this.hive});

  final HiveInterface hive;
  TextEditingController titleController = TextEditingController();
  int todoKey = -1;
  String title = '';
  RxBool isTitleEmpty = false.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxString isStartDateError = ''.obs;
  RxString isEndDateError = ''.obs;
  bool isCreate = false;

  @override
  void onInit() {
    isCreate = Get.arguments['isCreate'];
    todoKey = Get.arguments['todoKey'] ?? -1;
    if (isCreate) {
      DateTime now = DateTime.now();
      startDate.value = DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
        0,
      );
      endDate.value = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      );
    } else {
      setupItem(todoKey);
    }
    super.onInit();
  }

  /// Sets up the todoItem by it's [todoKey] for editing.
  setupItem(int todoKey) async {
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
    // isStartDateError.value = date.isEmpty ? 'Please select start date1' : '';
  }

  /// Sets the end [date] of the todoItem.
  void setEndDate(DateTime date) {
    endDate.value = date;
    // isEndDateError.value = date.isEmpty ? 'Please select end date1' : '';
  }

  /// Creates or updates the todoItem.
  Future<void> createUpdate() async {
    if (title.isEmpty) {
      isTitleEmpty.value = true;
      return;
    }
    // if (startDate.isEmpty) {
    //   isStartDateError.value = 'Please select start date2';
    // }
    // if (endDate.isEmpty) {
    //   isEndDateError.value = 'Please select end date2';
    // }
    // if (title.isEmpty || startDate.isEmpty || endDate.isEmpty) {
    //   return;
    // }

    if (startDate.value.isAfter(endDate.value)) {
      isEndDateError.value = AppString.endDateError.tr;
      return;
    }
    TodoBox box = TodoBox(hive: hive);
    if (isCreate) {
      await box.addNewItem(TodoItem(title, startDate.value, endDate.value, false, 0));
      Get.back(result: true);
    } else {
      TodoItem todoItem = await box.getItem(todoKey)
        ..title = title
        ..startDate = startDate.value
        ..endDate = endDate.value;
      await box.updateItem(todoKey, todoItem); // this is equal to ..save() but due to unit test save() will have error
      Get.back(result: true);
    }
  }
}
