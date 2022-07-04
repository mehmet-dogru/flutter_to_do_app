import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_to_do_app/controllers/task_controller.dart';
import 'package:flutter_to_do_app/models/task.dart';
import 'package:flutter_to_do_app/services/theme_service.dart';
import 'package:flutter_to_do_app/ui/helpers/colors.dart';
import 'package:flutter_to_do_app/ui/widgets/add_task_bar.dart';
import 'package:flutter_to_do_app/ui/widgets/button.dart';
import 'package:flutter_to_do_app/ui/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskController _taskController = TaskController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 16),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              if (_taskController.taskList[index].repeat == 'Daily') {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (_taskController.taskList[index].date ==
                  DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: DatePicker(
        DateTime.now(),
        daysCount: 10,
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: CustomColors.primaryClr,
        dayTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Get.isDarkMode ? CustomColors.white : Colors.grey,
        ),
        monthTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Get.isDarkMode ? CustomColors.white : Colors.grey,
        ),
        dateTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Get.isDarkMode ? CustomColors.white : CustomColors.primaryClr,
        ),
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = selectedDate;
          });
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 24,
                  color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
                ),
              ),
              const Text('Today',
                  style: TextStyle(fontFamily: 'Lato', fontSize: 30)),
            ],
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Get.isDarkMode
            ? const Icon(
                Icons.nightlight_round,
                size: 20,
                color: Colors.white,
              )
            : const Icon(
                Icons.light_mode_rounded,
                size: 20,
                color: Colors.black,
              ),
      ),
      actions: const [
        Icon(
          Icons.person,
          size: 20,
          color: Colors.blue,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? CustomColors.darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: 'Task Completed',
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    color: CustomColors.primaryClr,
                    context: context,
                  ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              color: Colors.red,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.red : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.red : color,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
