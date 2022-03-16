import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/utils/helpers/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasksList extends StatefulWidget {
  TasksList({Key key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final List<TaskCard> tasksList = TaskCard.generateTasks();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardController>(
        init: BoardController(),
        builder: (BoardController controller) {
          return Container(
            child: GridView.builder(
              itemCount: controller.activeUserProjects.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index) => tasksList[index]
                      .isLast
                  ? _buildAddTask()
                  : _buildTask(context, tasksList[index], controller, index),
            ),
          );
        });
  }

  Widget _buildAddTask() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(kBorderRadius),
      dashPattern: const <double>[10, 10],
      color: Colors.black54,
      strokeWidth: 2,
      child: const Center(
        child: Text(
          '+ Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTask(BuildContext context, TaskCard taskCard,
      BoardController controller, int index) {
    int projectId = -1;
    try {
      projectId = controller.activeUserProjects.value[index].projectId;
    } catch (e) {
      projectId = -1;
    }

    return Obx(() => InkWell(
      onTap: () {
        controller.selectProject(projectId);
      },
      child: Container(
            padding: const EdgeInsets.all(15),
            decoration: controller.selectedProject.value.projectId != projectId
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius),)
                : BoxDecoration(
                    color: taskCard.bgColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  taskCard.iconData,
                  color: taskCard.iconColor,
                  size: 25,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  controller.activeUserProjects.value[index].name,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    _buildTaskStatus(taskCard.btnColor, taskCard.iconColor,
                        '${controller.activeUserProjects.value.length} left'),
                    const SizedBox(width: 10),
                    _buildTaskStatus(
                        Colors.white, taskCard.iconColor, '${taskCard.done} done')
                  ],
                )
              ],
            ),
          ),
    ));
  }

  Widget _buildTaskStatus(Color bgColor, Color textColor, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(kBorderRadius)),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

class TaskCard {
  IconData iconData;
  String title;
  Color bgColor;
  Color iconColor;
  Color btnColor;
  num left;
  num done;
  bool isLast;
  TaskCard(
      {this.iconData,
      this.title,
      this.bgColor,
      this.iconColor,
      this.btnColor,
      this.left,
      this.done,
      this.isLast = false});

  static List<TaskCard> generateTasks() {
    return [
      TaskCard(
        iconData: Icons.cases_rounded,
        title: 'Work',
        bgColor: kBlueLight,
        iconColor: kBlueDark,
        btnColor: kBlue,
        left: 3,
        done: 1,
      ),
      TaskCard(
        iconData: Icons.health_and_safety,
        title: 'Health',
        bgColor: kYellowLight,
        iconColor: kYellowDark,
        btnColor: kYellow,
        left: 5,
        done: 2,
      ),
      TaskCard(
        iconData: Icons.person,
        title: 'Personal',
        bgColor: kRedLight,
        iconColor: kRedDark,
        btnColor: kRed,
        left: 5,
        done: 2,
      ),
      TaskCard(isLast: true),
    ];
  }
}
