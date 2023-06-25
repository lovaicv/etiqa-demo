import 'package:etiqa_demo/core/app_string.dart';
import 'package:etiqa_demo/pages/new_edit/new_edit_page_controller.dart';
import 'package:etiqa_demo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A widget which is displayed as the New/Edit screen of the application
class NewEditPage extends GetView<NewEditPageController> {
  const NewEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: const BackButton(color: Colors.black),
        title: Text(
          controller.isCreate ? AppString.addNewItem.tr : AppString.update.tr,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
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
                                style: const TextStyle(
                                    color: /*controller.startDate.value == 'Select a Date' ? Colors.grey :*/
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
            child: InkWell(
              onTap: () {
                controller.createUpdate();
              },
              child: Container(
                height: 50,
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  controller.isCreate ? AppString.createNew.tr : AppString.update.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
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
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
