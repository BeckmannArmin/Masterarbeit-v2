// ignore_for_file: prefer_if_elements_to_conditional_expressions, always_specify_types

import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/edit_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:beebusy_app/ui/widgets/edit_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/edit_task_dialogv2.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/status.dart';
import '../../service/SizeConfig.dart';
import 'alert_dialog.dart';
import 'circle_group.dart';

class DraggableTaskCard extends StatelessWidget {
  const DraggableTaskCard({Key key, @required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Draggable<Task>(
          data: task,
          child: TaskCard(task: task, width: constraints.maxWidth),
          feedback: TaskCard(task: task, width: constraints.maxWidth),
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({Key key, this.task, this.width}) : super(key: key);

  final Task task;
  final double width;

  @override
  Widget build(BuildContext context) {


    final List<String> images = [];

    for (final p0 in task.assignees) {
      images.add(p0.projectMember.user.nameInitials);
    }


    return
        Container(
      width: width,

      margin: EdgeInsets.only(bottom: MySize.size10),
      child: Card(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MySize.size16),
        ),
        child: InkWell(
            onTap: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      GetBuilder<EditTaskController>(
                    init: EditTaskController(task: task),
                    builder: (_) => EditTaskDialog(),
                  ),
                ),
            child: Container(
              padding: EdgeInsets.only(
                  left: MySize.size20,
                  right: MySize.size20,
                  top: MySize.size14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MySize.size16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        spreadRadius: 5,
                        blurRadius: 4)
                  ]),
              child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                         Chip(
                              backgroundColor: Theme.of(context).colorScheme.background,
                              label:const BrownText('Research',
                                 )),

                          MediaQuery.of(context).size.width >= 875? IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                size: MySize.size15,
                              )):Container()
                        ],
                      ),
                      MediaQuery.of(context).size.width >= 875? PopupMenuButton<int>(
                        child: Icon(
                          Icons.more_horiz,
                          size: MySize.size15,
                        ),
                        onSelected: (int a) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                MyAlertDialog(
                                  title: AppLocalizations.of(context)
                                      .deleteTaskTitle,
                                  content: AppLocalizations.of(context)
                                      .deleteTaskQuestion,
                                  onConfirm: () {
                                    Get.find<TaskController>()
                                        .deleteTask(task.taskId);
                                    Get.back<void>();
                                  },
                                ),
                          );
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<int>>[
                            PopupMenuItem(
                                child: Text(AppLocalizations.of(context)
                                        .deleteTaskTitle), value: 0),
                          ];
                        },
                      ):Container(),
                    ],
                  ),

                  MediaQuery.of(context).size.width >= 875 ? Container(): Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            //padding: EdgeInsets.all(2),
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              size: MySize.size15,
                            )),
                        PopupMenuButton<int>(
                          // padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.more_horiz,
                            size: MySize.size15,
                          ),
                          onSelected: (int a) {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) =>
                                  MyAlertDialog(
                                    title: AppLocalizations.of(context)
                                        .deleteTaskTitle,
                                    content: AppLocalizations.of(context)
                                        .deleteTaskQuestion,
                                    onConfirm: () {
                                      Get.find<TaskController>()
                                          .deleteTask(task.taskId);
                                      Get.back<void>();
                                    },
                                  ),
                            );
                          },
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<int>>[
                              PopupMenuItem(
                                  child: Text(AppLocalizations.of(context)
                                      .deleteTaskTitle), value: 0),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MySize.size8),
                  BrownText(
                    task.title,
                  ),

                  SizedBox(height: MySize.size8),
                  BrownText(
                    task.description,
                  ),
                  Container(
                    height: MySize.size60,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CircleGroup(
                                insideRadius: MySize.size18,

                                ///Determines how much in radius [Default value: 20]
                                outSideRadius: MySize.size20,

                                ///[outsideRadius must be gretter then insideRadius]Determines how much in radius [Default value: 24]
                                widthFactor: 0.5,
                                itemCount: images.length,

                                ///  Determines how much in horizontal they should overlap.[Default value: 0.6]
                                backgroundImage: images,
                                backgroundColor: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: MySize.size6),

                  ///TODO(armin)
                  // Text(
                  //   '${AppLocalizations.of(context).deadlineLabel}: ${task.deadline == null ? AppLocalizations.of(context).noDeadlineText : DateFormat.yMd().format(task.deadline)}',
                  //   style: TextStyle(
                  //     color: Theme.of(context).hintColor,
                  //     fontSize: 12,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: task.assignees.map((TaskAssignee assignee) {
                  //     return Padding(
                  //       padding: const EdgeInsets.only(right: 4),
                  //       child: AssigneeAvatar(assignee: assignee),
                  //     );
                  //   }).toList(),
                  // ),
                ],
              )
            )),
      ),
    );
  }
}

class AssigneeAvatar extends StatelessWidget {
  const AssigneeAvatar({Key key, this.assignee}) : super(key: key);

  final TaskAssignee assignee;

  @override
  Widget build(BuildContext context) {
    final String fullName =
        '${assignee?.projectMember?.user?.firstname ?? ""} ${assignee?.projectMember?.user?.lastname ?? ""}';
    return Tooltip(
      message: fullName,
      child: CircleAvatar(
        radius: MySize.size16,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          assignee.projectMember.user.nameInitials,
          style: TextStyle(
            fontSize: MySize.size14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}


class DraggableTaskCardRow extends StatelessWidget {
  const DraggableTaskCardRow({Key key, @required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Draggable<Task>(
          data: task,
          child: TaskCardRow(task: task, width: constraints.maxWidth),
          feedback: TaskCardRow(task: task, width: constraints.maxWidth),
          // not working, error from flutter when dragging
          // childWhenDragging: Opacity(
          //   opacity: 0.4,
          //   child: TaskCard(
          //       task: task,
          //       width: constraints.maxWidth),
          // ),
        );
      },
    );
  }
}

class TaskCardRow extends StatelessWidget {
  const TaskCardRow({Key key, this.task, this.width}) : super(key: key);

  final Task task;
  final double width;

  @override
  Widget build(BuildContext context) {

    final List<String> images = [];

    for (final p0 in task.assignees) {
      images.add(p0.projectMember.user.nameInitials);
    }


    return
      Container(
        // width: 300,
        width: MySize.size300,
        // margin: EdgeInsets.only(bottom: MySize.size10),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: InkWell(
              onTap: () => showModalBottomSheet<void>(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(kBorderRadius),
                              topLeft: Radius.circular(kBorderRadius)),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                context: context, builder: (BuildContext context) {
                  return GetBuilder<EditTaskController>(
                    init: EditTaskController(task: task),
                    builder: (_) => EditTaskDialogBottomSheet(),
                  );
                } ),
              child: Container(
                  padding: EdgeInsets.only(
                      left: MySize.size20,
                      right: MySize.size20,
                      top: MySize.size14),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      color: Theme.of(context).colorScheme.onPrimary,
                     ),
                  child:

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Chip(
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  label: const BrownText('Research')),

                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                     Icons.add,
                                    size: MySize.size15,
                                  ))
                            ],
                          ),
                           PopupMenuButton<int>(
                            child: Icon(
                              Icons.more_horiz,
                              size: MySize.size15,
                            ),
                            onSelected: (int a) {

                            final TaskController controller =   Get.find<TaskController>();




                              if(a==0){

                                controller.updateStatus(task, Status.todo);

                              //   status: Status.todo,
                              // columnTitle: AppLocalizations.of(context).todoColumnTitle,
                              }else if(a==1){
                                controller.updateStatus(task, Status.inProgress);
                              }else if(a==2){
                                controller.updateStatus(task, Status.review);
                              }else if(a==3){
                                controller.updateStatus(task, Status.done);
                              }else{
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      MyAlertDialog(
                                        title: AppLocalizations.of(context)
                                            .deleteTaskTitle,
                                        content: AppLocalizations.of(context)
                                            .deleteTaskQuestion,
                                        onConfirm: () {
                                          Get.find<TaskController>()
                                              .deleteTask(task.taskId);
                                          Get.back<void>();
                                        },
                                      ),
                                );
                              }


                            },
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry<int>>[
                                PopupMenuItem(
                                    child: Text(AppLocalizations.of(context).todoColumnTitle), value: 0),
                                PopupMenuItem(
                                    child: Text(AppLocalizations.of(context).inProgressColumnTitle), value: 1),
                                PopupMenuItem(
                                    child: Text(AppLocalizations.of(context).reviewColumnTitle), value: 2),
                                PopupMenuItem(
                                    child: Text(AppLocalizations.of(context).doneColumnTitle), value: 3),

                                PopupMenuItem(
                                    child: Text(AppLocalizations.of(context).deleteTaskTitle, style: const TextStyle(color: Colors.red),), value: 4),
                              ];
                            },
                          )
                        ],
                      ),

                      Expanded(child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(height: MySize.size8),
                      BrownText(
                        task.title,
                        fontSize: 24,
                      ),

                      SizedBox(height: MySize.size8),

                      BrownText(
                        task.description,
                      ),
                      ],)
                      ),
                      Container(
                        height: MySize.size60,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CircleGroup(
                                    insideRadius: MySize.size18,

                                    ///Determines how much in radius [Default value: 20]
                                    outSideRadius: MySize.size20,

                                    ///[outsideRadius must be gretter then insideRadius]Determines how much in radius [Default value: 24]
                                    widthFactor: 0.5,
                                    itemCount: images.length,

                                    ///  Determines how much in horizontal they should overlap.[Default value: 0.6]
                                    backgroundImage: images,
                                    backgroundColor: Colors.white)),
                              Container(
                                child: BrownText(
                                  DateFormat('dd.MM.yyyy').format(task.deadline),
                                ),
                              )
                            ,
                          ],
                        ),
                      ),
                      SizedBox(height: MySize.size6),
                    ],
                  )
              )),
        ),
      );
  }
}