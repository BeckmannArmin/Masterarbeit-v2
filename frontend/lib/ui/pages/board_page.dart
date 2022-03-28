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
import 'package:beebusy_app/ui/widgets/drawer_widget.dart';
import 'package:beebusy_app/ui/widgets/no_projects_view.dart';
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
import '../widgets/search_bar.dart';

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
                              left: MySize.size15,
                              right: MySize.size15,
                              top: MySize.size15),
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
        : DesktopView();

    return widget;
  }

  RxInt selectedAction = 0.obs;

  List<Widget> actionsWidget;

  Widget mobileView(BuildContext context) {
    final GlobalKey<State<StatefulWidget>> dataKey = GlobalKey();
    final double width = MediaQuery.of(context).size.width;

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
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
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
                  _buildSearchBar(controller),
                  _buildProgress(
                    dataKey,
                    controller,
                    axis: Axis.vertical,
                  ),
                  const SizedBox(
                    height: kSpacing,
                  ),
                  BrownText(
                    'Meine Tasks',
                    fontSize: MySize.size25,
                    isBold: true,
                  ),
                  /* Obx(
                   () => Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: ShadowText(
                          controller.newTasks.length == 1
                              ? 'Du hast ${controller.newTasks.length} unerledigte Aufgabe.'
                              : 'Du hast ${controller.newTasks.length} unerledigte Aufgaben.',
                          style: GoogleFonts.poppins(
                              fontSize: MySize.size20,
                              color: Theme.of(context).primaryColor),
                        ),
                      )
                  ), */
                ],
              ),
            ),
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
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MySize.size10,
                              right: MySize.size10,
                              top: 6,
                              bottom: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          child: Chip(
                            elevation: selectedAction.value == i ? 4 : 2,
                            shadowColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kBorderRadius))),
                            backgroundColor: Theme.of(context).colorScheme.onPrimary,
                            label: Container(
                                padding: EdgeInsets.only(
                                    left: MySize.size10,
                                    right: MySize.size10,
                                    top: 6,
                                    bottom: 6),
                                height: 55,
                                child: Text(
                                  actions[i],
                                  style: GoogleFonts.poppins(
                                    fontSize: selectedAction.value == i
                                        ? MySize.size16
                                        : MySize.size14,
                                  ),
                                )),
                          ),
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

  Widget DesktopView() {
    return Obx(
      () => Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  controller.selectedProject.value?.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: MySize.size48,
                    color: const Color(0xff313133),
                  ),
                ),
                Container(
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
                ),
              ]),
              SizedBox(
                height: MySize.size12,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.',
                style: GoogleFonts.inter(
                    fontSize: MySize.size15,
                    color: const Color(0xff6E7073).withOpacity(0.64)),
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
          DragTargetBoardColumn(
            status: Status.todo,
            columnTitle: AppLocalizations.of(context).todoColumnTitle,
            showCreateCardIconButton: true,
          ),
          DragTargetBoardColumn(
            status: Status.inProgress,
            columnTitle: AppLocalizations.of(context).inProgressColumnTitle,
          ),
          DragTargetBoardColumn(
            status: Status.review,
            columnTitle: AppLocalizations.of(context).reviewColumnTitle,
          ),
          DragTargetBoardColumn(
            status: Status.done,
            columnTitle: AppLocalizations.of(context).doneColumnTitle,
          ),
        ],
      ),
    );
  }
}

class DragTargetBoardColumn extends GetView<TaskController> {
  const DragTargetBoardColumn({
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
          width: MediaQuery.of(context).size.width / 5.3,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BoardColumn(
                status: status,
                columnTitle: columnTitle,
                showCreateCardIconButton: showCreateCardIconButton,
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
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final bool showCreateCardIconButton;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.black;
    switch (status) {
      case Status.todo:
        bgColor = Colors.black;
        break;
      case Status.done:
        bgColor = const Color(0xff72CA71);
        break;
      case Status.inProgress:
        bgColor = const Color(0xff408AFA);
        break;
      case Status.review:
        bgColor = Colors.teal;
        break;
    }

    final ScrollController _scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: MySize.size8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Chip(
                  padding: EdgeInsets.all(MySize.size12),
                  backgroundColor: bgColor,
                  label: Text(
                    columnTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MySize.size10,
                        fontWeight: FontWeight.bold),
                  )),
            ],
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

Widget _buildSearchBar(BoardController controller) {

  final List<Task> allTasks = controller.tasks.toList();
  List<Task> tasks = allTasks;
  
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search tasks',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: const BorderSide(color: Colors.blue)
            ) 
          ),
          onChanged: (String value) {
            controller.filterTasks(value);
          },
        ),
      ),
      Container(
        height: 500,
        color: Colors.red.shade100,
        child: 
        Obx(
         () => ListView.builder(
                   itemCount: controller.foundTasks.length,
                   itemBuilder: (BuildContext context, int index) {
                     final Task task = controller.foundTasks[index];

                     return ListTile(
                       title: Text(task.title),
                     );
                   }
             )
        )
      ),
    ],
  );
}

Widget _buildProgress(GlobalKey key, BoardController controller,
    {Axis axis = Axis.horizontal}) {
  return (axis == Axis.horizontal)
      ? Row(
          children: <Widget>[
            Flexible(
              flex: 5,
              child: ProgressCard(
                  data: ProgressCardData(
                      totalTaskInProgress: controller.tasks.length,
                      totalUndone: controller.newTasks.length)),
            ),
            Flexible(
                flex: 4,
                child: Obx(() => ProgressReportCard(
                    data: ProgressReportCardData(
                        percent: .5,
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
                        percent: (controller.doneTasks.length * 100) / (controller.doneTasks.length + controller.newTasks.length),
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
    Color bgColor = Colors.black;
    switch (status) {
      case Status.todo:
        bgColor = Colors.black;
        break;
      case Status.done:
        bgColor = const Color(0xff72CA71);
        break;
      case Status.inProgress:
        bgColor = const Color(0xff408AFA);
        break;
      case Status.review:
        bgColor = Colors.teal;
        break;
    }

    final ScrollController _scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: MySize.size8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(
          width: double.infinity,
          height: MySize.size200,
          child: Obx(
            () => Scrollbar(
              key: ValueKey<int>(controller.tasks.length),
              controller: _scrollController,
              child: ListView(
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
