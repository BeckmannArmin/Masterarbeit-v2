import 'package:beebusy_app/controller/edit_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:beebusy_app/ui/widgets/edit_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_group_avatar/overlay_group_avatar.dart';

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

class TaskCard extends StatelessWidget {
  const TaskCard({Key key, this.task, this.width}) : super(key: key);

  final Task task;
  final double width;

  @override
  Widget build(BuildContext context) {


    List<String> images = [];

    task.assignees.forEach((p0) {
      images.add(p0.projectMember.user.nameInitials);
    });


    return

        // Container(
        //     // width: 329,
        //     // width: width,

        //     // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //     child: Card(
        //   elevation: 0,
        //   child: InkWell(
        //       onTap: () => showDialog<void>(
        //             context: context,
        //             builder: (BuildContext context) =>
        //                 GetBuilder<EditTaskController>(
        //               init: EditTaskController(task: task),
        //               builder: (_) => EditTaskDialog(),
        //             ),
        //           ),
        //       child: Container(
        // margin: EdgeInsets.only(bottom: 16),
        // padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.black.withOpacity(0.02),
        //           spreadRadius: 5,
        //           blurRadius: 4)
        //     ]),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   BrownText(task.title),
        //                   Text(
        //                     '${AppLocalizations.of(context).deadlineLabel}: ${task.deadline == null ? AppLocalizations.of(context).noDeadlineText : DateFormat.yMd().format(task.deadline)}',
        //                     style: TextStyle(
        //                       color: Theme.of(context).hintColor,
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                   const SizedBox(height: 8),
        //                   Row(
        //                     children: task.assignees.map((TaskAssignee assignee) {
        //                       return Padding(
        //                         padding: const EdgeInsets.only(right: 4),
        //                         child: AssigneeAvatar(assignee: assignee),
        //                       );
        //                     }).toList(),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             const SizedBox(width: 32),
        //             IconButton(
        //               icon: Icon(
        //                 Icons.delete,
        //                 color: Theme.of(context).hintColor,
        //                 size: 16,
        //               ),
        //               onPressed: () => showDialog<void>(
        //                 context: context,
        //                 builder: (BuildContext context) => MyAlertDialog(
        //                   title: AppLocalizations.of(context).deleteTaskTitle,
        //                   content: AppLocalizations.of(context).deleteTaskQuestion,
        //                   onConfirm: () {
        //                     Get.find<TaskController>().deleteTask(task.taskId);
        //                     Get.back<void>();
        //                   },
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       )),
        // ));

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
              // margin: EdgeInsets.only(bottom: 16),
              //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
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
                              backgroundColor: Color(0xff5BB4A9),
                              label: Text("Research",
                                  style: TextStyle(
                                      fontSize: MySize.size10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))),

                          MediaQuery.of(context).size.width >= 875? IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color:
                                Color(0xffB3B3C0).withOpacity(0.64),
                                size: MySize.size15,
                                // size: 10,
                              )):Container()
                        ],
                      ),
                      MediaQuery.of(context).size.width >= 875? PopupMenuButton<int>(
                        child: Icon(
                          Icons.more_horiz,
                          color: Color(0xffE2E3E5),
                          // size: 10,
                          size: MySize.size15,
                        ),
                        onSelected: (a) {
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
                        itemBuilder: (context) {
                          return <PopupMenuEntry<int>>[
                            PopupMenuItem(
                                child: Text('Delete'), value: 0),
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
                              color:
                              Color(0xffB3B3C0).withOpacity(0.64),
                              size: MySize.size15,
                              // size: 10,
                            )),
                        PopupMenuButton<int>(
                          // padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.more_horiz,
                            color: Color(0xffE2E3E5),
                            // size: 10,
                            size: MySize.size15,
                          ),
                          onSelected: (a) {
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
                          itemBuilder: (context) {
                            return <PopupMenuEntry<int>>[
                              PopupMenuItem(
                                  child: Text('Delete'), value: 0),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MySize.size8),
                  // Container(
                  //   width: double.infinity,
                  //   height: MySize.size140,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(MySize.size12),
                  //     image: DecorationImage(
                  //         image: AssetImage('icons/image.png'),
                  //         fit: BoxFit.cover),
                  //   ),
                  // ),
                  // SizedBox(height: MySize.size8),
                  Text(
                    task.title,
                    style: TextStyle(
                        color: Color(0xff313133),
                        fontSize: MySize.size24,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: MySize.size8),
                  Text(
                    task.description,
                    style: TextStyle(
                        color: Color(0xff313133).withOpacity(0.64),
                        fontSize: MySize.size10),
                  ),

                  MediaQuery.of(context).size.width > 999 ? Container()
                  :Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Row(

                              children: [
                                Spacer(),
                                Image.asset(
                                  'icons/comment.png',
                                  width: MySize.size12,
                                  height: MySize.size12,
                                ),
                                Spacer(),
                                Text(
                                  "4 Comments",
                                  style: TextStyle(
                                      fontSize: MySize.size8,
                                      color:
                                      Color(0xff313133).withOpacity(0.4)),
                                ),
                                Spacer(),
                                Image.asset(
                                  'icons/link.png',
                                  width: MySize.size20,
                                  height: MySize.size20,
                                ),
                                Spacer(),
                                Text(
                                  "1 File",
                                  style: TextStyle(
                                      fontSize: MySize.size8,
                                      color:
                                      Color(0xff313133).withOpacity(0.4)),
                                ),
                              ],
                            ))
                      ],
                    ),
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
                        MediaQuery.of(context).size.width > 999 ?
                        Expanded(
                          flex: 2,
                            child: Row(

                              children: [
                                Spacer(),
                                Image.asset(
                                  'icons/comment.png',
                                  width: MySize.size12,
                                  height: MySize.size12,
                                ),
                                Spacer(),
                                Text(
                                  "4 Comments",
                                  style: TextStyle(
                                      fontSize: MySize.size8,
                                      color:
                                      Color(0xff313133).withOpacity(0.4)),
                                ),
                                Spacer(),
                                Image.asset(
                                  'icons/link.png',
                                  width: MySize.size20,
                                  height: MySize.size20,
                                ),
                                Spacer(),
                                Text(
                                  "1 File",
                                  style: TextStyle(
                                      fontSize: MySize.size8,
                                      color:
                                      Color(0xff313133).withOpacity(0.4)),
                                ),
                              ],
                            ))
                            :Container()
                      ],
                    ),
                  ),
                  SizedBox(height: MySize.size6),

                  ///todo: I've commented
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

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   Chip(
              //                       backgroundColor: Color(0xff5BB4A9),
              //                       label: Text("Research",
              //                           style: TextStyle(
              //                               fontSize: MySize.size10,
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.w500))),
              //                   SizedBox(
              //                     width: MySize.size8,
              //                   ),
              //                   IconButton(
              //                       onPressed: () {},
              //                       icon: Icon(
              //                         Icons.add,
              //                         color:
              //                             Color(0xffB3B3C0).withOpacity(0.64),
              //                         size: MySize.size15,
              //                       ))
              //                 ],
              //               ),
              //               PopupMenuButton<int>(
              //                 child: Icon(
              //                   Icons.more_horiz,
              //                   color: Color(0xffE2E3E5),
              //                 ),
              //                 onSelected: (a) {
              //                   showDialog<void>(
              //                     context: context,
              //                     builder: (BuildContext context) =>
              //                         MyAlertDialog(
              //                       title: AppLocalizations.of(context)
              //                           .deleteTaskTitle,
              //                       content: AppLocalizations.of(context)
              //                           .deleteTaskQuestion,
              //                       onConfirm: () {
              //                         Get.find<TaskController>()
              //                             .deleteTask(task.taskId);
              //                         Get.back<void>();
              //                       },
              //                     ),
              //                   );
              //                 },
              //                 itemBuilder: (context) {
              //                   return <PopupMenuEntry<int>>[
              //                     PopupMenuItem(
              //                         child: Text('Delete'), value: 0),
              //                   ];
              //                 },
              //               ),
              //             ],
              //           ),
              //           SizedBox(height: MySize.size8),
              //           Container(
              //             width: double.infinity,
              //             height: MySize.size140,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(MySize.size12),
              //               image: DecorationImage(
              //                   image: AssetImage('icons/image.png'),
              //                   fit: BoxFit.cover),
              //             ),
              //           ),
              //           SizedBox(height: MySize.size8),
              //           Text(
              //             task.title,
              //             style: TextStyle(
              //                 color: Color(0xff313133),
              //                 fontSize: MySize.size24,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //
              //           Text(
              //             task.description,
              //             style: TextStyle(
              //                 color: Color(0xff313133).withOpacity(0.64),
              //                 fontSize: MySize.size10),
              //           ),
              //
              //           Container(
              //             height: MySize.size60,
              //             child: Row(
              //               children: [
              //                 Expanded(
              //                     flex: 0,
              //                     child: OverlapAvatar(
              //                         insideRadius: MySize.size18,
              //
              //                         ///Determines how much in radius [Default value: 20]
              //                         outSideRadius: MySize.size20,
              //
              //                         ///[outsideRadius must be gretter then insideRadius]Determines how much in radius [Default value: 24]
              //                         widthFactor: 0.5,
              //                         itemCount: 2,
              //
              //                         ///  Determines how much in horizontal they should overlap.[Default value: 0.6]
              //                         backgroundImage: AssetImage(
              //                           'icons/image1.png',
              //                         ),
              //                         backgroundColor: Colors.white)),
              //                 Expanded(
              //                     child: Row(
              //                   children: [
              //                     Image.asset(
              //                       'icons/comment.png',
              //                       width: MySize.size12,
              //                       height: MySize.size12,
              //                     ),
              //                     SizedBox(
              //                       width: MySize.size3,
              //                     ),
              //                     Text(
              //                       "4 Comments",
              //                       style: TextStyle(
              //                           fontSize: MySize.size8,
              //                           color:
              //                               Color(0xff313133).withOpacity(0.4)),
              //                     ),
              //                     SizedBox(
              //                       width: MySize.size12,
              //                     ),
              //                     Image.asset(
              //                       'icons/link.png',
              //                       width: MySize.size20,
              //                       height: MySize.size20,
              //                     ),
              //                     SizedBox(
              //                       width: MySize.size3,
              //                     ),
              //                     Text(
              //                       "1 File",
              //                       style: TextStyle(
              //                           fontSize: MySize.size8,
              //                           color:
              //                               Color(0xff313133).withOpacity(0.4)),
              //                     ),
              //                   ],
              //                 ))
              //               ],
              //             ),
              //           ),
              //           SizedBox(height: MySize.size6),
              //
              //           ///todo: I've commented
              //           // Text(
              //           //   '${AppLocalizations.of(context).deadlineLabel}: ${task.deadline == null ? AppLocalizations.of(context).noDeadlineText : DateFormat.yMd().format(task.deadline)}',
              //           //   style: TextStyle(
              //           //     color: Theme.of(context).hintColor,
              //           //     fontSize: 12,
              //           //   ),
              //           // ),
              //           // const SizedBox(height: 8),
              //           // Row(
              //           //   children: task.assignees.map((TaskAssignee assignee) {
              //           //     return Padding(
              //           //       padding: const EdgeInsets.only(right: 4),
              //           //       child: AssigneeAvatar(assignee: assignee),
              //           //     );
              //           //   }).toList(),
              //           // ),
              //         ],
              //       ),
              //     ),
              //
              //     /// todo: i've did
              //
              //     // const SizedBox(width: 32),
              //     // IconButton(
              //     //   icon: Icon(
              //     //     Icons.delete,
              //     //     color: Theme.of(context).hintColor,
              //     //     size: 16,
              //     //   ),
              //     //   onPressed: () => showDialog<void>(
              //     //     context: context,
              //     //     builder: (BuildContext context) => MyAlertDialog(
              //     //       title: AppLocalizations.of(context).deleteTaskTitle,
              //     //       content:
              //     //           AppLocalizations.of(context).deleteTaskQuestion,
              //     //       onConfirm: () {
              //     //         Get.find<TaskController>().deleteTask(task.taskId);
              //     //         Get.back<void>();
              //     //       },
              //     //     ),
              //     //   ),
              //     // )
              //   ],
              // ),
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

    List<String> images = [];

    task.assignees.forEach((p0) {
      images.add(p0.projectMember.user.nameInitials);
    });


    return

      // Container(
      //     // width: 329,
      //     // width: width,

      //     // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      //     child: Card(
      //   elevation: 0,
      //   child: InkWell(
      //       onTap: () => showDialog<void>(
      //             context: context,
      //             builder: (BuildContext context) =>
      //                 GetBuilder<EditTaskController>(
      //               init: EditTaskController(task: task),
      //               builder: (_) => EditTaskDialog(),
      //             ),
      //           ),
      //       child: Container(
      // margin: EdgeInsets.only(bottom: 16),
      // padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(16),
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //           color: Colors.black.withOpacity(0.02),
      //           spreadRadius: 5,
      //           blurRadius: 4)
      //     ]),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   BrownText(task.title),
      //                   Text(
      //                     '${AppLocalizations.of(context).deadlineLabel}: ${task.deadline == null ? AppLocalizations.of(context).noDeadlineText : DateFormat.yMd().format(task.deadline)}',
      //                     style: TextStyle(
      //                       color: Theme.of(context).hintColor,
      //                       fontSize: 12,
      //                     ),
      //                   ),
      //                   const SizedBox(height: 8),
      //                   Row(
      //                     children: task.assignees.map((TaskAssignee assignee) {
      //                       return Padding(
      //                         padding: const EdgeInsets.only(right: 4),
      //                         child: AssigneeAvatar(assignee: assignee),
      //                       );
      //                     }).toList(),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             const SizedBox(width: 32),
      //             IconButton(
      //               icon: Icon(
      //                 Icons.delete,
      //                 color: Theme.of(context).hintColor,
      //                 size: 16,
      //               ),
      //               onPressed: () => showDialog<void>(
      //                 context: context,
      //                 builder: (BuildContext context) => MyAlertDialog(
      //                   title: AppLocalizations.of(context).deleteTaskTitle,
      //                   content: AppLocalizations.of(context).deleteTaskQuestion,
      //                   onConfirm: () {
      //                     Get.find<TaskController>().deleteTask(task.taskId);
      //                     Get.back<void>();
      //                   },
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       )),
      // ));

      Container(
        // width: 300,
        width: MySize.size300,
        // margin: EdgeInsets.only(bottom: MySize.size10),
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
                // margin: EdgeInsets.only(bottom: 16),
                //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
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
                                  backgroundColor: Color(0xff5BB4A9),
                                  label: Text("Research",
                                      style: TextStyle(
                                          fontSize: MySize.size10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500))),

                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                     Icons.add,
                                    color:
                                    Color(0xffB3B3C0).withOpacity(0.64),
                                    size: MySize.size15,
                                    // size: 10,
                                  ))
                            ],
                          ),
                           PopupMenuButton<int>(
                            child: Icon(
                              Icons.more_horiz,
                              color: Color(0xffE2E3E5),
                              // size: 10,
                              size: MySize.size15,
                            ),
                            onSelected: (a) {

                            TaskController controller =   Get.find<TaskController>();




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
                            itemBuilder: (context) {
                              return <PopupMenuEntry<int>>[
                                PopupMenuItem(
                                    child: Text('To-Do'), value: 0),
                                PopupMenuItem(
                                    child: Text('In-progress'), value: 1),
                                PopupMenuItem(
                                    child: Text('In Review'), value: 2),
                                PopupMenuItem(
                                    child: Text('Completed'), value: 3),

                                PopupMenuItem(
                                    child: Text('Delete'), value: 4),
                              ];
                            },
                          )
                        ],
                      ),

                      SizedBox(height: MySize.size8),
                      // Container(
                      //   width: double.infinity,
                      //   height: MySize.size140,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(MySize.size12),
                      //     image: DecorationImage(
                      //         image: AssetImage('icons/image.png'),
                      //         fit: BoxFit.cover),
                      //   ),
                      // ),
                      // SizedBox(height: MySize.size8),
                      Text(
                        task.title,
                        style: TextStyle(
                            color: Color(0xff313133),
                            fontSize: MySize.size24,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: MySize.size8),

                      Text(
                        task.description,
                        style: TextStyle(
                            color: Color(0xff313133).withOpacity(0.64),
                            fontSize: MySize.size10),
                      ),


                      // MediaQuery.of(context).size.width >= 875 ? Container()
                      //     :Container(
                      //   margin: EdgeInsets.only(top: 5),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //           flex: 2,
                      //           child: Row(
                      //
                      //             children: [
                      //               Spacer(),
                      //               Image.asset(
                      //                 'icons/comment.png',
                      //                 width: MySize.size12,
                      //                 height: MySize.size12,
                      //               ),
                      //               Spacer(),
                      //               Text(
                      //                 "4 Comments",
                      //                 style: TextStyle(
                      //                     fontSize: MySize.size8,
                      //                     color:
                      //                     Color(0xff313133).withOpacity(0.4)),
                      //               ),
                      //               Spacer(),
                      //               Image.asset(
                      //                 'icons/link.png',
                      //                 width: MySize.size20,
                      //                 height: MySize.size20,
                      //               ),
                      //               Spacer(),
                      //               Text(
                      //                 "1 File",
                      //                 style: TextStyle(
                      //                     fontSize: MySize.size8,
                      //                     color:
                      //                     Color(0xff313133).withOpacity(0.4)),
                      //               ),
                      //             ],
                      //           ))
                      //     ],
                      //   ),
                      // ),

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

                            Expanded(
                                flex: 2,
                                child: Row(

                                  children: [
                                    Spacer(),
                                    Image.asset(
                                      'icons/comment.png',
                                      width: MySize.size12,
                                      height: MySize.size12,
                                    ),
                                    Spacer(),
                                    Text(
                                      "4 Comments",
                                      style: TextStyle(
                                          fontSize: MySize.size8,
                                          color:
                                          Color(0xff313133).withOpacity(0.4)),
                                    ),
                                    Spacer(),
                                    Image.asset(
                                      'icons/link.png',
                                      width: MySize.size20,
                                      height: MySize.size20,
                                    ),
                                    Spacer(),
                                    Text(
                                      "1 File",
                                      style: TextStyle(
                                          fontSize: MySize.size8,
                                          color:
                                          Color(0xff313133).withOpacity(0.4)),
                                    ),
                                  ],
                                ))

                          ],
                        ),
                      ),
                      SizedBox(height: MySize.size6),

                      ///todo: I've commented
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

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Row(
                //                 children: [
                //                   Chip(
                //                       backgroundColor: Color(0xff5BB4A9),
                //                       label: Text("Research",
                //                           style: TextStyle(
                //                               fontSize: MySize.size10,
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w500))),
                //                   SizedBox(
                //                     width: MySize.size8,
                //                   ),
                //                   IconButton(
                //                       onPressed: () {},
                //                       icon: Icon(
                //                         Icons.add,
                //                         color:
                //                             Color(0xffB3B3C0).withOpacity(0.64),
                //                         size: MySize.size15,
                //                       ))
                //                 ],
                //               ),
                //               PopupMenuButton<int>(
                //                 child: Icon(
                //                   Icons.more_horiz,
                //                   color: Color(0xffE2E3E5),
                //                 ),
                //                 onSelected: (a) {
                //                   showDialog<void>(
                //                     context: context,
                //                     builder: (BuildContext context) =>
                //                         MyAlertDialog(
                //                       title: AppLocalizations.of(context)
                //                           .deleteTaskTitle,
                //                       content: AppLocalizations.of(context)
                //                           .deleteTaskQuestion,
                //                       onConfirm: () {
                //                         Get.find<TaskController>()
                //                             .deleteTask(task.taskId);
                //                         Get.back<void>();
                //                       },
                //                     ),
                //                   );
                //                 },
                //                 itemBuilder: (context) {
                //                   return <PopupMenuEntry<int>>[
                //                     PopupMenuItem(
                //                         child: Text('Delete'), value: 0),
                //                   ];
                //                 },
                //               ),
                //             ],
                //           ),
                //           SizedBox(height: MySize.size8),
                //           Container(
                //             width: double.infinity,
                //             height: MySize.size140,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(MySize.size12),
                //               image: DecorationImage(
                //                   image: AssetImage('icons/image.png'),
                //                   fit: BoxFit.cover),
                //             ),
                //           ),
                //           SizedBox(height: MySize.size8),
                //           Text(
                //             task.title,
                //             style: TextStyle(
                //                 color: Color(0xff313133),
                //                 fontSize: MySize.size24,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //
                //           Text(
                //             task.description,
                //             style: TextStyle(
                //                 color: Color(0xff313133).withOpacity(0.64),
                //                 fontSize: MySize.size10),
                //           ),
                //
                //           Container(
                //             height: MySize.size60,
                //             child: Row(
                //               children: [
                //                 Expanded(
                //                     flex: 0,
                //                     child: OverlapAvatar(
                //                         insideRadius: MySize.size18,
                //
                //                         ///Determines how much in radius [Default value: 20]
                //                         outSideRadius: MySize.size20,
                //
                //                         ///[outsideRadius must be gretter then insideRadius]Determines how much in radius [Default value: 24]
                //                         widthFactor: 0.5,
                //                         itemCount: 2,
                //
                //                         ///  Determines how much in horizontal they should overlap.[Default value: 0.6]
                //                         backgroundImage: AssetImage(
                //                           'icons/image1.png',
                //                         ),
                //                         backgroundColor: Colors.white)),
                //                 Expanded(
                //                     child: Row(
                //                   children: [
                //                     Image.asset(
                //                       'icons/comment.png',
                //                       width: MySize.size12,
                //                       height: MySize.size12,
                //                     ),
                //                     SizedBox(
                //                       width: MySize.size3,
                //                     ),
                //                     Text(
                //                       "4 Comments",
                //                       style: TextStyle(
                //                           fontSize: MySize.size8,
                //                           color:
                //                               Color(0xff313133).withOpacity(0.4)),
                //                     ),
                //                     SizedBox(
                //                       width: MySize.size12,
                //                     ),
                //                     Image.asset(
                //                       'icons/link.png',
                //                       width: MySize.size20,
                //                       height: MySize.size20,
                //                     ),
                //                     SizedBox(
                //                       width: MySize.size3,
                //                     ),
                //                     Text(
                //                       "1 File",
                //                       style: TextStyle(
                //                           fontSize: MySize.size8,
                //                           color:
                //                               Color(0xff313133).withOpacity(0.4)),
                //                     ),
                //                   ],
                //                 ))
                //               ],
                //             ),
                //           ),
                //           SizedBox(height: MySize.size6),
                //
                //           ///todo: I've commented
                //           // Text(
                //           //   '${AppLocalizations.of(context).deadlineLabel}: ${task.deadline == null ? AppLocalizations.of(context).noDeadlineText : DateFormat.yMd().format(task.deadline)}',
                //           //   style: TextStyle(
                //           //     color: Theme.of(context).hintColor,
                //           //     fontSize: 12,
                //           //   ),
                //           // ),
                //           // const SizedBox(height: 8),
                //           // Row(
                //           //   children: task.assignees.map((TaskAssignee assignee) {
                //           //     return Padding(
                //           //       padding: const EdgeInsets.only(right: 4),
                //           //       child: AssigneeAvatar(assignee: assignee),
                //           //     );
                //           //   }).toList(),
                //           // ),
                //         ],
                //       ),
                //     ),
                //
                //     /// todo: i've did
                //
                //     // const SizedBox(width: 32),
                //     // IconButton(
                //     //   icon: Icon(
                //     //     Icons.delete,
                //     //     color: Theme.of(context).hintColor,
                //     //     size: 16,
                //     //   ),
                //     //   onPressed: () => showDialog<void>(
                //     //     context: context,
                //     //     builder: (BuildContext context) => MyAlertDialog(
                //     //       title: AppLocalizations.of(context).deleteTaskTitle,
                //     //       content:
                //     //           AppLocalizations.of(context).deleteTaskQuestion,
                //     //       onConfirm: () {
                //     //         Get.find<TaskController>().deleteTask(task.taskId);
                //     //         Get.back<void>();
                //     //       },
                //     //     ),
                //     //   ),
                //     // )
                //   ],
                // ),
              )),
        ),
      );
  }
}