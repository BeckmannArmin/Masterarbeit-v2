// ignore_for_file: prefer_if_elements_to_conditional_expressions

import 'dart:ui';

import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/navigation/custom_animated_bar.dart';
import 'package:beebusy_app/service/SizeConfig.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:beebusy_app/ui/widgets/add_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/board_navigation.dart';
import 'package:beebusy_app/ui/widgets/bottom_navigation_bar.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/no_projects_view.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/taks_info_cards.dart';
import 'package:beebusy_app/ui/widgets/task_card.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth_controller.dart';
import '../../controller/create_project_controller.dart';
import '../../model/user.dart';
import '../widgets/search_bar.dart';

class BoardPage extends GetView<BoardController> {
  static const String route = '/board';

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

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
       fab: MediaQuery.of(context).size.width <= 820
              ? Material(
                  shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(.4),
                  elevation: 10,
                  shape: const StadiumBorder(),
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius)),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
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
                    child: const Center(
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                )
              : Material(
                  shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(.4),
                  elevation: 10,
                  shape: const StadiumBorder(),
                  child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
                        children: [
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
                ),
          //bottomNavigationBar: MyBottomNavigationBar(),
          key: drawerKey,
          drawer: Drawer(
            child: drawerWidget(context),
          ),
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: <Widget>[
                controller.activeUserProjects.isEmpty ?
                  NoProjectsView()
                : BoardNavigation(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MySize.size15,
                        right: MySize.size15,
                        top: MySize.size15),
                    child: MediaQuery.of(context).size.width <= 820
                        ? SingleChildScrollView(
                            child: Column(
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

  Widget drawerWidget(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border(
          right: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: MySize.size24, right: MySize.size10, top: MySize.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GetX<AuthController>(builder: (AuthController controller) {
                  final User user = controller.loggedInUser.value;
                  return ListTile(
                      minLeadingWidth: MySize.size15,
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        '${user.firstname} ${user.lastname}',
                        style: TextStyle(
                            fontSize: MySize.size18,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          drawerKey.currentState.closeDrawer();
                        },
                        child: CircleAvatar(
                          radius: MySize.size10,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MySize.size3,
                                  top: MySize.size2,
                                  bottom: MySize.size2),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: MySize.size10,
                              ),
                            ),
                          ),
                        ),
                      ));
                }),
                SizedBox(
                  height: MySize.size8,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(.05),
          ),
          SizedBox(
            height: MySize.size8,
          ),
          Padding(
            padding: EdgeInsets.only(left: MySize.size16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).projectsLabel,
                  style: TextStyle(
                      fontSize: MySize.size14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: MySize.size16, right: MySize.size24, top: MySize.size8),
              child: ListView.builder(
                itemBuilder: (BuildContext ctx, int i) {
                  String title = '';

                  try {
                    title = controller.activeUserProjects.value[i].name;
                  } catch (e) {
                    title = '';
                  }

                  int projectId = -1;
                  try {
                    projectId =
                        controller.activeUserProjects.value[i].projectId;
                  } catch (e) {
                    projectId = -1;
                  }

                  return Obx(() => Container(
                        decoration: controller
                                    .selectedProject.value.projectId !=
                                projectId
                            ? const BoxDecoration()
                            : BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                                boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        spreadRadius: 4,
                                        blurRadius: MySize.size10)
                                  ]),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () {
                            controller.selectProject(projectId);
                          },
                          leading: Padding(
                            padding: EdgeInsets.only(
                                left: MySize.size8,
                                top: MySize.size12,
                                bottom: MySize.size12),
                            child: Container(
                              width: MySize.size20,
                              height: MySize.size20,
                              decoration: BoxDecoration(
                                  color: controller.selectedProject.value
                                              .projectId !=
                                          projectId
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.secondary,
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius)),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: controller.selectedProject.value
                                              .projectId !=
                                          projectId
                                      ? Colors.black
                                      : Colors.white,
                                  size: MySize.size13,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            title,
                            style: TextStyle(
                                fontSize: MySize.size16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ));
                },
                itemCount: controller.activeUserProjects.value.length,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextButton.icon(
                  onPressed: () {
                   _onButtonPressed(context);
                  },
                  icon: const Icon(
                    Icons.add_task_outlined,
                    size: 24.0,
                  ),
                  label: Text(AppLocalizations.of(context).createProjectTitle, style: const TextStyle(fontWeight: FontWeight.bold),)),
            ),
          ),
          SizedBox(
            height: MySize.size16,
          ),
        ],
      ),
    );
  }

  void _onButtonPressed(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final AuthController authController = Get.find();
    final BoardController boardController = Get.find();
     final GlobalKey<FormState> _formKey = GlobalKey();

    showModalBottomSheet<dynamic>(context: context, builder: (BuildContext context) {
      return GetBuilder<CreateProjectController>(
        init: CreateProjectController(),
        builder: (CreateProjectController controller) {
          return Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(.1),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },
                       child: Text(AppLocalizations.of(context).cancelButton, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                       ),
                       Text(
                       AppLocalizations.of(context).createProjectTitle, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)
                       ),
                       TextButton(onPressed: () {
                          if (_formKey.currentState.validate() && controller.projectMembers.isNotEmpty) {
                            controller.createProject();
                          }
                       },
                       child: Text(AppLocalizations.of(context).saveLabel, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                       )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                 Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: 
                    RoundedInput(validator: (String value) {
                      if(value.isBlank) {
                                return AppLocalizations.of(context).emptyError;
                              }
            
                              if(value.length > 50) {
                                return AppLocalizations.of(context).length50Error;
                              }
            
                              return null;
                    },icon: Icons.list, size: const Size(30,30), labelText: 'Name',)),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                      child: Column(
                        children: <Widget>[     
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 250
                            ),
                            child: Obx(
                                  () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      MyDropDown<User>(
                                        width: double.infinity,
                                        hintText: AppLocalizations.of(context)
                                            .addTeamMemberLabel,
                                        possibleSelections: controller.userList,
                                        onChanged: controller.addProjectMember,
                                        valueBuilder: (User user) => user.userId,
                                        textBuilder: (User user) =>
                                            '${user.firstname} ${user.lastname}',
                                      ).build(context),
                                      const SizedBox(height: 5),
                                      Expanded(
                                        child: Scrollbar(
                                          key: ValueKey<int>(controller.projectMembers.length),
                                          controller: _scrollController,
                                          thumbVisibility: true,
                                          child: ListView(
                                            controller: _scrollController,
                                            children: <Widget>[
                                              ...controller.projectMembers
                                                  .toList()
                                                  .map(
                                                    (User u) => TeamMemberContainer(
                                                      name:
                                                          '${u.firstname} ${u.lastname}',
                                                      onPressed: () => controller
                                                          .removeProjectMember(u.userId),
                                                      removable: authController
                                                              .loggedInUser
                                                              .value
                                                              .userId !=
                                                          u.userId,
                                                    ),
                                                  )
                                                  .toList(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      );
    },
    elevation: 5,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(kBorderRadius), topRight: Radius.circular(kBorderRadius))
    )
    );
  }

  Widget drawerSide(BuildContext context) {
    final Widget widget =
        MediaQuery.of(context).size.width <= 820 ? mobileView(context) : DesktopView();

    return widget;
  }

  RxInt selectedAction = 0.obs;

  List<Widget> actionsWidget;

  Widget mobileView(BuildContext context) {
    final List<String> actions = [AppLocalizations.of(context).todoColumnTitle, AppLocalizations.of(context).inProgressColumnTitle, AppLocalizations.of(context).reviewColumnTitle, AppLocalizations.of(context).doneColumnTitle];
    return Container(
          color: Theme.of(context).colorScheme.background,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container( 
                  width: double.infinity,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            drawerKey.currentState.openDrawer();
                          },
                          icon: const Icon(Icons.menu)),
                      const Spacer(),
                      Container(
                        width: 150,
                        child: Expanded(
                              child: Text(
                                controller.selectedProject.value.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      ),
                      const Spacer(),
                      Container(
                        width: MySize.size42,
                        height: MySize.size42,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              controller.selectProfile();
                            },
                            icon: const Icon(Icons.person),
                            //color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MySize.size20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetX<AuthController>(builder: (AuthController controller) {
                    final User user = controller.loggedInUser.value;
                    return BrownText(
                      'Hey ${user.firstname}!',
                     fontSize: MySize.size30,
                     isBold: true,
                    );
                  }),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: ShadowText(
                      'Du hast ${controller.tasks.length} unerledigte Aufgaben.',
                      style: GoogleFonts.poppins(
                          fontSize: MySize.size20, color: Theme.of(context).primaryColor),
                    ),
                  ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MySize.size25,
                ),
                Container(
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
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                  ),
                              child: Chip(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(kBorderRadius))),
                                backgroundColor: selectedAction.value == i
                                    ? Theme.of(context).primaryColor.withOpacity(0.15)
                                    :  Theme.of(context).primaryColor.withOpacity(0.05),
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
                    itemCount: 4,
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
            children: [
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
                    children: [
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

  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
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
