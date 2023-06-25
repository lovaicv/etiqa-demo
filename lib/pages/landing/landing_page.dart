import 'package:etiqa_demo/core/app_string.dart';
import 'package:etiqa_demo/core/routes.dart';
import 'package:etiqa_demo/database/todo_db.dart';
import 'package:etiqa_demo/pages/landing/landing_page_controller.dart';
import 'package:etiqa_demo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

/// A widget which is displayed as the landing screen of the application
class LandingPage extends GetView<LandingPageController> {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    // elevation: 16,
                    // style: const TextStyle(color: Colors.deepPurple),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.deepPurpleAccent,
                    // ),
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
                    // elevation: 16,
                    // style: const TextStyle(color: Colors.deepPurple),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.deepPurpleAccent,
                    // ),
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
      body:
          // ValueListenableBuilder(
          //   key:controller.key,
          //     valueListenable: Hive.box(todoDB).listenable(),
          //     builder: (context, Box<dynamic> box, widget) {
          //       List<Todo> todoList = box.values.map((items) => items as Todo).toList();
          //
          //       bool ascending = controller.orderBy.value == 'Ascending';
          //       bool descending = controller.orderBy.value == 'Descending';
          //
          //       todoList.forEach((todo) {
          //         Duration duration = myDateFormat().parse(todo.endDate).difference(DateTime.now());
          //         todo.timeLeft = duration.inMilliseconds;
          //       });
          //
          //       switch (controller.sortBy.value) {
          //         case 'Default':
          //           todoList.sort((a, b) => ascending ? a.key.compareTo(b.key) : b.key.compareTo(a.key));
          //           break;
          //         case 'Title':
          //           todoList.sort((a, b) => ascending ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
          //           break;
          //         case 'Start Date':
          //           todoList.sort((a, b) => ascending ? a.startDate.compareTo(b.startDate) : b.startDate.compareTo(a.startDate));
          //           break;
          //         case 'End Date':
          //           todoList.sort((a, b) => ascending ? a.endDate.compareTo(b.endDate) : b.endDate.compareTo(a.endDate));
          //           break;
          //         case 'Time Left':
          //           todoList.sort((a, b) => ascending ? a.timeLeft.compareTo(b.timeLeft) : b.timeLeft.compareTo(a.timeLeft));
          //           break;
          //         case 'Status':
          //           todoList.sort((a, b) => ascending ? (a.isComplete ? 1 : -1) : (b.isComplete ? 1 : -1));
          //           break;
          //       }
          //
          //       return Stack(
          //         children: [
          //           ListView.separated(
          //               padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
          //               itemBuilder: (BuildContext context, int index) {
          //                 Todo todo = todoList[index];
          //                 Duration duration = myDateFormat().parse(todo.endDate).difference(DateTime.now());
          //                 bool expired = myDateFormat().parse(todo.endDate).isBefore(DateTime.now());
          //                 return Slidable(
          //                   key: const ValueKey(0),
          //                   endActionPane: ActionPane(
          //                     motion: const ScrollMotion(),
          //                     // dismissible: DismissiblePane(onDismissed: () {}),
          //                     children: [
          //                       SlidableAction(
          //                         onPressed: (BuildContext context) {
          //                           controller.deleteItem(todo.key);
          //                         },
          //                         backgroundColor: const Color(0xFFFE4A49),
          //                         foregroundColor: Colors.white,
          //                         icon: Icons.delete,
          //                         label: 'Delete',
          //                       ),
          //                     ],
          //                   ),
          //                   child: InkWell(
          //                     onTap: () async {
          //                       dynamic result = await Get.toNamed(Routes.edit, arguments: {
          //                         'isCreate': false,
          //                         'todoKey': todo.key,
          //                       });
          //                       // if (result is bool && result) {
          //                       //   controller.getTodoList();
          //                       // }
          //                     },
          //                     child: Container(
          //                         decoration: BoxDecoration(
          //                           color: Colors.white,
          //                           borderRadius: const BorderRadius.all(Radius.circular(8)),
          //                           boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 8)],
          //                         ),
          //                         child: Column(
          //                           crossAxisAlignment: CrossAxisAlignment.stretch,
          //                           children: [
          //                             const SizedBox(height: 20),
          //                             Container(
          //                                 padding: const EdgeInsets.symmetric(horizontal: 15),
          //                                 child: Text(
          //                                   todo.title,
          //                                   style: const TextStyle(fontWeight: FontWeight.bold),
          //                                 )),
          //                             const SizedBox(height: 20),
          //                             Container(
          //                               padding: const EdgeInsets.symmetric(horizontal: 15),
          //                               child: IntrinsicHeight(
          //                                 child: Row(
          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Flexible(
          //                                       child: Column(
          //                                         crossAxisAlignment: CrossAxisAlignment.start,
          //                                         children: [
          //                                           const Text('Start Date'),
          //                                           const SizedBox(height: 5),
          //                                           Text(
          //                                             todo.startDate,
          //                                             style: const TextStyle(fontWeight: FontWeight.bold),
          //                                           ),
          //                                         ],
          //                                       ),
          //                                     ),
          //                                     Flexible(
          //                                       child: Column(
          //                                         crossAxisAlignment: CrossAxisAlignment.start,
          //                                         children: [
          //                                           const Text('End Date'),
          //                                           const SizedBox(height: 5),
          //                                           Text(
          //                                             todo.endDate,
          //                                             style: const TextStyle(fontWeight: FontWeight.bold),
          //                                           ),
          //                                         ],
          //                                       ),
          //                                     ),
          //                                     Flexible(
          //                                       child: Column(
          //                                         crossAxisAlignment: CrossAxisAlignment.start,
          //                                         children: [
          //                                           const Text('Time left'),
          //                                           const SizedBox(height: 5),
          //                                           Text(
          //                                             expired
          //                                                 ? 'expired'
          //                                                 : '${duration.inDays} days ${duration.inHours & 24} hrs ${duration.inMinutes % 60} min',
          //                                             style: TextStyle(color: expired ? Colors.red : Colors.black, fontWeight: FontWeight.bold),
          //                                           ),
          //                                         ],
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             const SizedBox(height: 20),
          //                             Container(
          //                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //                                 decoration: const BoxDecoration(
          //                                   color: Color(0xffe6e3cf),
          //                                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          //                                 ),
          //                                 child: Row(
          //                                   children: [
          //                                     const Text('Status '),
          //                                     Expanded(
          //                                         child: Text(
          //                                       todo.isComplete ? 'Completed' : 'Incomplete',
          //                                       style: TextStyle(
          //                                         color: todo.isComplete ? Colors.green : Colors.red,
          //                                         fontWeight: FontWeight.bold,
          //                                       ),
          //                                     )),
          //                                     const Text('Tick if completed'),
          //                                     const SizedBox(width: 10),
          //                                     SizedBox(
          //                                       width: 20,
          //                                       height: 20,
          //                                       child: Checkbox(
          //                                           value: todo.isComplete,
          //                                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //                                           onChanged: (bool? value) {
          //                                             controller.updateItem(todo.key, !todo.isComplete);
          //                                           }),
          //                                     ),
          //                                   ],
          //                                 ))
          //                           ],
          //                         )),
          //                   ),
          //                 );
          //               },
          //               separatorBuilder: (BuildContext context, int index) {
          //                 return const SizedBox(
          //                   height: 20,
          //                 );
          //               },
          //               itemCount: todoList.length),
          //           Center(
          //             child: Visibility(
          //               visible: todoList.isEmpty,
          //               child: const Text('no result'),
          //             ),
          //           ),
          //         ],
          //       );
          //     }),
          Obx(() => Stack(
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
                            // dismissible: DismissiblePane(onDismissed: () {}),
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
                            onTap: () async {
                              dynamic result = await Get.toNamed(Routes.edit, arguments: {
                                'isCreate': false,
                                'todoKey': todo.key,
                              });
                              if (result is bool && result) {
                                controller.getTodoList();
                              }
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
                                                    style:
                                                        TextStyle(color: expired ? Colors.red : Colors.black, fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
