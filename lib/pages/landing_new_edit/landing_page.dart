import 'package:etiqa_demo/core/app_string.dart';
import 'package:etiqa_demo/core/routes.dart';
import 'package:etiqa_demo/database/todo_db.dart';
import 'package:etiqa_demo/pages/landing_new_edit/landing_page_controller.dart';
import 'package:etiqa_demo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:dual_screen/dual_screen.dart';

/// A widget which is displayed as the landing screen of the application
class LandingPage extends GetView<LandingPageController> {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isTablet) {
      return TwoPane(startPane: landing(context), endPane: newEdit(context));
    }
    return landing(context);
  }

  landing(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.grey[300],
      endDrawer: Container(
        color: Colors.white,
        width: Get.width * 3 / 4,
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppString.sortBy.tr),
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: controller.sortBy.value,
                    icon: Container(alignment: Alignment.centerRight, child: const Icon(Icons.arrow_drop_down)),
                    onChanged: (String? value) {
                      controller.setSortBy(value);
                    },
                    items: controller.sortByList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 20),
              Text(AppString.orderBy.tr),
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: controller.orderBy.value,
                    icon: Container(alignment: Alignment.centerRight, child: const Icon(Icons.arrow_drop_down)),
                    onChanged: (String? value) {
                      controller.setOrderBy(value);
                    },
                    items: controller.orderByList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              Expanded(
                  child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            controller.setOrderBy(controller.orderByList[0]);
                            controller.setSortBy(controller.sortByList[0]);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                AppString.reset.tr,
                                textAlign: TextAlign.center,
                              ))),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            controller.scaffoldKey.currentState?.closeEndDrawer();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                AppString.close.tr,
                                textAlign: TextAlign.center,
                              ))),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          AppString.todoList.tr,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          InkWell(
            onTap: () {
              controller.scaffoldKey.currentState?.openEndDrawer();
            },
            child: Container(
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.sort,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      body: Obx(() => Stack(
            children: [
              ListView.separated(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                  itemBuilder: (BuildContext context, int index) {
                    TodoItem todo = controller.todoList[index];
                    Duration duration = todo.endDate.difference(DateTime.now());
                    bool expired = todo.endDate.isBefore(DateTime.now());
                    return Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              controller.deleteItem(todo.key);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: AppString.delete.tr,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: context.isPhone
                            ? () async {
                                dynamic result = await Get.toNamed(Routes.edit, arguments: {
                                  'isCreate': false,
                                  'todoKey': todo.key,
                                });
                                if (result is bool && result) {
                                  controller.getTodoList();
                                }
                              }
                            : () {
                                controller.setupItem(todo.key);
                              },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 8)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      todo.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    )),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(AppString.startDate.tr),
                                              const SizedBox(height: 5),
                                              Text(
                                                myDateFormat().format(todo.startDate),
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(AppString.endDate.tr),
                                              const SizedBox(height: 5),
                                              Text(
                                                myDateFormat().format(todo.endDate),
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(AppString.timeLeft.tr),
                                              const SizedBox(height: 5),
                                              Text(
                                                expired
                                                    ? AppString.expired.tr
                                                    : '${duration.inDays} ${AppString.days.tr} ${duration.inHours % 24} ${AppString.hrs.tr} ${duration.inMinutes % 60} ${AppString.min.tr}',
                                                style: TextStyle(color: expired ? Colors.red : Colors.black, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffe6e3cf),
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text('${AppString.status.tr} '),
                                        Expanded(
                                            child: Text(
                                          todo.isComplete ? AppString.completed.tr : AppString.incomplete.tr,
                                          style: TextStyle(
                                            color: todo.isComplete ? Colors.green : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                        InkWell(
                                            onTap: () {
                                              controller.updateItem(todo.key, !todo.isComplete);
                                            },
                                            child: Text(AppString.tickIfCompleted.tr)),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                              value: todo.isComplete,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              onChanged: (bool? value) {
                                                controller.updateItem(todo.key, !todo.isComplete);
                                              }),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: controller.todoList.length),
              Center(
                child: Visibility(
                  visible: controller.todoList.isEmpty,
                  child: Text(AppString.noResult.tr),
                ),
              ),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: context.isPhone,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[900],
          onPressed: () async {
            dynamic result = await Get.toNamed(Routes.edit, arguments: {
              'isCreate': true,
            });
            if (result is bool && result) {
              controller.getTodoList();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  newEdit(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: context.isPhone ? const BackButton(color: Colors.black) : null,
        title: Obx(() => Text(
              controller.isCreate.value ? AppString.addNewItem.tr : AppString.createUpdate.tr,
              style: const TextStyle(color: Colors.black),
            )),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  Text(AppString.todoTitle.tr),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      focusNode: controller.focusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppString.todoTitleHint.tr,
                      ),
                      onChanged: (String value) {
                        controller.setTitle(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(() => Visibility(
                        visible: controller.isTitleEmpty.value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            AppString.enterSomeText.tr,
                            style: TextStyle(color: Colors.red[800]),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Text(AppString.startDate.tr),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: GetPlatform.isAndroid || GetPlatform.isWeb
                        ? () async {
                            controller.focusNode.unfocus();
                            DateTime? value = await showDatePicker(
                                context: context,
                                initialDate: controller.startDate.value,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365)));
                            if (value != null) {
                              controller.setStartDate(DateTime(
                                value.year,
                                value.month,
                                value.day,
                                0,
                                0,
                                0,
                              ));
                            }
                          }
                        : () {
                            controller.focusNode.unfocus();
                            DateTime now = DateTime.now();
                            DateTime minDate = DateTime(now.year - 1);
                            DateTime maxDate = DateTime(now.year + 1);
                            _showDialog(CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: controller.startDate.value,
                              minimumDate: minDate,
                              maximumDate: maxDate,
                              onDateTimeChanged: (DateTime value) {
                                controller.setStartDate(DateTime(
                                  value.year,
                                  value.month,
                                  value.day,
                                  0,
                                  0,
                                  0,
                                ));
                              },
                            ));
                          },
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                myDateFormat().format(controller.startDate.value),
                                style: const TextStyle(color: Colors.black),
                              )),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(() => Visibility(
                        visible: controller.isStartDateError.isNotEmpty,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            controller.isStartDateError.value,
                            style: TextStyle(color: Colors.red[800]),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Text(AppString.estimatedEndDate.tr),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: GetPlatform.isAndroid || GetPlatform.isWeb
                        ? () async {
                            controller.focusNode.unfocus();
                            DateTime? value = await showDatePicker(
                                context: context,
                                initialDate: controller.endDate.value,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365)));
                            if (value != null) {
                              controller.setEndDate(DateTime(
                                value.year,
                                value.month,
                                value.day,
                                0,
                                0,
                                0,
                              ));
                            }
                          }
                        : () {
                            controller.focusNode.unfocus();
                            DateTime now = DateTime.now();
                            DateTime minDate = DateTime(now.year - 1);
                            DateTime maxDate = DateTime(now.year + 1);
                            _showDialog(CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: controller.endDate.value,
                              minimumDate: minDate,
                              maximumDate: maxDate,
                              onDateTimeChanged: (DateTime value) {
                                controller.setEndDate(DateTime(
                                  value.year,
                                  value.month,
                                  value.day,
                                  23,
                                  59,
                                  59,
                                ));
                              },
                            ));
                          },
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                myDateFormat().format(controller.endDate.value),
                                style: const TextStyle(
                                    color: /*controller.endDate.value == 'Select a Date' ? Colors.grey :*/
                                        Colors.black),
                              )),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(() => Visibility(
                        visible: controller.isEndDateError.isNotEmpty,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            controller.isEndDateError.value,
                            style: TextStyle(color: Colors.red[800]),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.createUpdate(true);
                    },
                    child: Container(
                      height: 50,
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Text(
                        AppString.createNew.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Obx(() => Visibility(
                    visible: context.isTablet && controller.todoKey.value != -1,
                    child: Container(
                      width: 1,
                      color: Colors.white,
                    ))),
                Obx(() => Visibility(
                      visible: context.isTablet && controller.todoKey.value != -1,
                      child: Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.createUpdate(false);
                          },
                          child: Container(
                            height: 50,
                            color: Colors.black,
                            alignment: Alignment.center,
                            child: Text(
                              AppString.update.tr,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
