// ignore_for_file: prefer_if_elements_to_conditional_expressions

import 'dart:ui';

import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/service/SizeConfig.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:beebusy_app/ui/widgets/add_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/board_navigation.dart';
import 'package:beebusy_app/ui/widgets/button_widget.dart';
import 'package:beebusy_app/ui/widgets/drawer_widget.dart';
import 'package:beebusy_app/ui/widgets/no_projects_view.dart';
import 'package:beebusy_app/ui/widgets/no_tasks_view.dart';
import 'package:beebusy_app/ui/widgets/progress_card.dart';
import 'package:beebusy_app/ui/widgets/report_card.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/task_card.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth_controller.dart';
import '../../model/user.dart';
import '../widgets/add_task_bottom_sheet.dart';

class BoardPage extends GetView<BoardController> {
  static const String route = '/board';

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    actionsWidget = <Widget>[
      DragTargetBoardRow(
        status: Status.todo,
        columnTitle: AppLocalizations.of(context).todoColumnTitle,
        showCreateCardIconButton: true,
      ),
      DragTargetBoardRow(
        status: Status.inProgress,
        columnTitle: AppLocalizations.of(context).inProgressColumnTitle,
      ),
      DragTargetBoardRow(
        status: Status.review,
        columnTitle: AppLocalizations.of(context).reviewColumnTitle,
      ),
      DragTargetBoardRow(
        status: Status.done,
        columnTitle: AppLocalizations.of(context).doneColumnTitle,
      ),
    ];

    return GetBuilder<BoardController>(builder: (BoardController controller) {
      return MyScaffold(
          showActions: true,
          fab: controller.tabIndex == 0
              ? MediaQuery.of(context).size.width <= 820
                  ? Material(
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(.4),
                      elevation: 10,
                      shape: const StadiumBorder(),
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius)),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(kBorderRadius),
                                  topLeft: Radius.circular(kBorderRadius)),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            context: context,
                            builder: (BuildContext context) =>
                                GetBuilder<CreateTaskController>(
                              init: CreateTaskController(),
                              builder: (_) => AddTaskDialogBottomSheet(),
                            ),
                          );
                        },
                        child: const Center(
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                      ),
                    )
                  : Material(
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(.4),
                      elevation: 10,
                      shape: const StadiumBorder(),
                      child: FloatingActionButton.extended(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) =>
                                  GetBuilder<CreateTaskController>(
                                init: CreateTaskController(),
                                builder: (_) => AddTaskDialog(),
                              ),
                            );
                          },
                          label: Row(
                            children: <Widget>[
                              Text(
                                'Task hinzufügen ',
                                style: TextStyle(
                                    fontSize: MySize.size14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Icon(
                                Icons.add,
                                size: MySize.size14,
                              )
                            ],
                          )),
                    )
              : null,
          drawer: DrawerSide(),
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: <Widget>[
                controller.activeUserProjects.isEmpty
                    ? NoProjectsView()
                    : BoardNavigation(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MySize.size36,
                              right: MySize.size36,
                              top: MySize.size36),
                          child: MediaQuery.of(context).size.width <= 820
                              ? SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      drawerSide(context),
                                      MediaQuery.of(context).size.width <= 820
                                          ? Container()
                                          : Expanded(
                                              child: Board(),
                                            ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    drawerSide(context),
                                    MediaQuery.of(context).size.width <= 820
                                        ? Container()
                                        : Expanded(
                                            child: Board(),
                                          ),
                                  ],
                                ),
                        ),
                      ),
                SettingsPage(),
                ProfilePage()
              ],
            ),
          ));
    });
  }

  Widget drawerSide(BuildContext context) {
    final Widget widget = MediaQuery.of(context).size.width <= 820
        ? mobileView(context)
        : desktopView(context);

    return widget;
  }

  RxInt selectedAction = 0.obs;

  List<Widget> actionsWidget;

  Widget mobileView(BuildContext context) {
    final GlobalKey<State<StatefulWidget>> dataKey = GlobalKey();

    final List<String> actions = <String>[
      AppLocalizations.of(context).todoColumnTitle,
      AppLocalizations.of(context).inProgressColumnTitle,
      AppLocalizations.of(context).reviewColumnTitle,
      AppLocalizations.of(context).doneColumnTitle
    ];
    return Container(
        color: Theme.of(context).colorScheme.background,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MySize.size20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GetX<AuthController>(builder: (AuthController controller) {
                  final User user = controller.loggedInUser.value;
                  return BrownText(
                    'Hey, ${user.firstname}!',
                    fontSize: MySize.size25,
                    isBold: true,
                  );
                }),
                const SizedBox(
                  height: kSpacing,
                ),
                _buildProgress(controller, axis: Axis.vertical, key: dataKey),
                const SizedBox(
                  height: kSpacing,
                ),
                BrownText(
                  'Meine Tasks',
                  fontSize: MySize.size25,
                  isBold: true,
                ),
              ],
            ),
            SizedBox(
              height: MySize.size25,
            ),
            _buildTracker(),
             SizedBox(
              height: MySize.size25,
            ),
            Container(
              key: dataKey,
              width: double.infinity,
              height: 55,
              child: ListView.builder(
                itemBuilder: (BuildContext ctx, int i) {
                  return Obx(() => InkWell(
                        onTap: () {
                          selectedAction.value = i;
                        },
                        child: Chip(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(kBorderRadius))),
                          backgroundColor: Colors.transparent,
                          label: Container(
                              margin:
                                  const EdgeInsets.only(right: kSpacing * .75),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                actions[i],
                                style: GoogleFonts.poppins(
                                    fontSize: MySize.size14,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAction.value == i
                                        ? const Color(0xFFFAAB21)
                                        : Colors.grey),
                              )),
                        ),
                      ));
                },
                itemCount: actions.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: MySize.size12,
            ),
            Obx(() => Container(
                  width: double.infinity,
                  height: MySize.size400 + MySize.size2,
                  child: actionsWidget[selectedAction.value],
                )),
            SizedBox(
              height: MySize.size8,
            ),
          ],
        ));
  }

  Widget _buildTracker() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius)
      ),
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Projekt Zeit Tracker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Text('Tracke deine Tasks', style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14
                  ),)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(kBorderRadius)
              ),
              child: IconButton(
                onPressed: () {
                      
              }, icon: const Icon(Icons.play_arrow, color: Colors.black,)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return SizedBox(
      height: 125,
      width: 125,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CircularProgressIndicator(
            value: controller.count / 100,
          ),
          Center(
            child: _buildTime(),
          )
        ],
      ),
    );
  }

  Widget _buildTime() {
    return Text(
      '${controller.count}',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
    );
  }

  Widget _buildButtons() {
    final bool isRunning = controller.isRunning;
    final bool isPaused = controller.isPaused;

    return isRunning
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonWidget(
                text: isPaused ? 'Pause' : 'Resume',
                onClicked: () {
                  if (isPaused) {
                    controller.stopTimer(reset: false);
                  } else {
                    controller.startTimer(reset: false);
                  }
                },
              ),
              ButtonWidget(
                text: 'Stop',
                onClicked: () {
                  controller.resetTimer();
                },
              ),
            ],
          )
        : ButtonWidget(
            text: 'Start Timer',
            onClicked: () {
              controller.startTimer(reset: false);
            },
          );
  }

  Widget desktopView(BuildContext context) {
    return Obx(
      () => Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      controller.selectedProject.value?.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MySize.size48,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),
                    /*  Container(
                  width: MySize.size396,
                  height: MySize.size40,
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                        child: SearchInput(
                          textController: null,
                          hintText: 'Suche nach Aufgaben',
                        ),
                      ),
                      SizedBox(
                        width: MySize.size20,
                      ),
                      Container(
                        child: Image.asset(
                          'icons/bell.png',
                          width: MySize.size20,
                          height: MySize.size20,
                        ),
                      ),
                    ],
                  ),
                ), */
                  ]),
              GetX<AuthController>(builder: (AuthController controller) {
                final User user = controller.loggedInUser.value;
                return BrownText(
                  'Hey, ${user.firstname}!',
                  fontSize: MySize.size25,
                  isBold: true,
                );
              }),
              const SizedBox(
                height: kSpacing,
              ),
              _buildProgress(
                controller,
                axis: Axis.horizontal,
              ),
              SizedBox(
                height: MySize.size12,
              ),
            ],
          )),
    );
  }
}

class Board extends GetView<BoardController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MySize.size16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Obx(() => DragTargetBoardColumn(
                status: Status.todo,
                columnTitle: AppLocalizations.of(context).todoColumnTitle,
                showCreateCardIconButton: true,
                taskCount: controller.toDoTasks.length,
              )),
          Obx(() => DragTargetBoardColumn(
                status: Status.inProgress,
                columnTitle: AppLocalizations.of(context).inProgressColumnTitle,
                taskCount: controller.inProgress.length,
              )),
          Obx(() => DragTargetBoardColumn(
                status: Status.review,
                columnTitle: AppLocalizations.of(context).reviewColumnTitle,
                taskCount: controller.reviewTasks.length,
              )),
          Obx(() => DragTargetBoardColumn(
                status: Status.done,
                columnTitle: AppLocalizations.of(context).doneColumnTitle,
                taskCount: controller.doneTasks.length,
              )),
        ],
      ),
    );
  }
}

class DragTargetBoardColumn extends GetView<TaskController> {
  const DragTargetBoardColumn({
    @required this.status,
    @required this.columnTitle,
    this.taskCount,
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final bool showCreateCardIconButton;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Task>(
      onWillAccept: (Task data) => data.status != status,
      onAccept: (Task data) {
        controller.updateStatus(data, status);
      },
      builder: (
        BuildContext context,
        List<Task> candidateData,
        List<dynamic> rejectedData,
      ) {
        return Container(
          width: MediaQuery.of(context).size.width / 5.3,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BoardColumn(
                status: status,
                columnTitle: columnTitle,
                showCreateCardIconButton: showCreateCardIconButton,
                taskCount: taskCount,
              ),
              if (candidateData.isNotEmpty)
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.01),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BoardColumn extends GetView<BoardController> {
  const BoardColumn({
    @required this.status,
    @required this.columnTitle,
    this.taskCount,
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final int taskCount;
  final bool showCreateCardIconButton;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: MySize.size8),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(kBorderRadius)),
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    columnTitle,
                    style: TextStyle(
                        fontSize: MySize.size14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Text(
                    '$taskCount',
                    style: TextStyle(
                        fontSize: MySize.size10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => Scrollbar(
              key: ValueKey<int>(controller.tasks.length),
              controller: _scrollController,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: MySize.size8,
                ),
                controller: _scrollController,
                children: controller.tasks
                    .where((Task task) => task.status == status)
                    .map((Task task) => DraggableTaskCard(task: task))
                    .toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 2.0,
            left: 2.0,
            child: Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Text(data, style: style),
          ),
        ],
      ),
    );
  }
}

// TODO(armin): spacing

class DragTargetBoardRow extends GetView<TaskController> {
  const DragTargetBoardRow({
    @required this.status,
    @required this.columnTitle,
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final bool showCreateCardIconButton;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Task>(
      onWillAccept: (Task data) => data.status != status,
      onAccept: (Task data) {
        controller.updateStatus(data, status);
      },
      builder: (
        BuildContext context,
        List<Task> candidateData,
        List<dynamic> rejectedData,
      ) {
        return Container(
          width: MySize.size400,
          height: MySize.size400,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BoardRow(
                status: status,
                columnTitle: columnTitle,
                showCreateCardIconButton: showCreateCardIconButton,
              ),
              if (candidateData.isNotEmpty)
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildProgress(BoardController controller,
    {Axis axis = Axis.horizontal, GlobalKey key}) {
  return (axis == Axis.horizontal)
      ? Row(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: ProgressCard(
                  data: ProgressCardData(
                      totalTaskInProgress: controller.tasks.length,
                      totalUndone: controller.newTasks.length)),
            ),
            Flexible(
                flex: 4,
                child: Obx(() => ProgressReportCard(
                    data: ProgressReportCardData(
                        percent: (controller.doneTasks.length * 100) /
                            (controller.doneTasks.length +
                                controller.newTasks.length),
                        title: controller.selectedProject.value.name,
                        task: controller.tasks.length,
                        doneTask: controller.doneTasks.length,
                        undoneTask: controller.newTasks.length)))),
          ],
        )
      : Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Obx(() => ProgressCard(
                  onPressedCheck: () {
                    Scrollable.ensureVisible(key.currentContext);
                  },
                  data: ProgressCardData(
                      totalTaskInProgress: controller.tasks.length,
                      totalUndone: controller.newTasks.length))),
            ),
            Flexible(
                flex: 4,
                child: Obx(() => ProgressReportCard(
                    data: ProgressReportCardData(
                        percent: (controller.doneTasks.length * 100) /
                            (controller.doneTasks.length +
                                controller.newTasks.length),
                        title: controller.selectedProject.value.name,
                        task: controller.tasks.length,
                        doneTask: controller.doneTasks.length,
                        undoneTask: controller.newTasks.length)))),
          ],
        );
}

class BoardRow extends GetView<BoardController> {
  const BoardRow({
    @required this.status,
    @required this.columnTitle,
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final bool showCreateCardIconButton;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: MySize.size8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        controller.newTasks.isEmpty
            ? const EmptyTaskView()
            : Container(
                width: double.infinity,
                height: MySize.size200,
                child: Obx(
                  () => Scrollbar(
                    radius: const Radius.circular(kBorderRadius),
                    key: ValueKey<int>(controller.tasks.length),
                    controller: _scrollController,
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 15),
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      children: controller.tasks
                          .where((Task task) => task.status == status)
                          .map((Task task) => DraggableTaskCardRow(task: task))
                          .toList(),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
