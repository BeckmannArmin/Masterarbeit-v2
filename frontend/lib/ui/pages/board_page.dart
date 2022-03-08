import 'dart:ui';

import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/service/SizeConfig.dart';
import 'package:beebusy_app/ui/widgets/add_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/board_navigation.dart';
import 'package:beebusy_app/ui/widgets/no_projects_view.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/task_card.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth_controller.dart';
import '../../controller/create_project_controller.dart';
import '../../model/user.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/header_profile.dart';

class BoardPage extends GetView<BoardController> {
  static const String route = '/board';

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

    return MyScaffold(
      showActions: true,
      key: scaffoldKey,
      fab: MediaQuery.of(context).size.width <= 820?
      Material(
        shadowColor: const Color(0xff408AFA),
        elevation: 10,
        shape: const StadiumBorder(),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
            backgroundColor: const Color(0xff408AFA),
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
          child: const Center(child: const Icon(Icons.add,color: Colors.white,),),
            // label: Row(
            //   children: [
            //     Text(
            //       "Add New Task ",
            //       style: TextStyle(
            //           color: Colors.white,
            //           fontSize: MySize.size14,
            //           fontWeight: FontWeight.w500),
            //     ),
            //     Icon(
            //       Icons.add,
            //       color: Colors.white,
            //       size: MySize.size14,
            //     )
            //   ],
            // )
        ),
      )
          :
      Material(
        shadowColor: const Color(0xff408AFA),
        elevation: 10,
        shape: const StadiumBorder(),
        child: FloatingActionButton.extended(
            backgroundColor: const Color(0xff408AFA),
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
                  'Add New Task ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MySize.size14,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: MySize.size14,
                )
              ],
            )),
      ),
      drawer: Drawer(
        child: drawerWidget(context),
      ),
      body: Obx(
        () {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isLoadingUserProjects.value
                ? Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : controller.activeUserProjects.isEmpty
                    ? NoProjectsView()
                    : BoardNavigation(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MySize.size20, right: MySize.size20, top: MySize.size20),
                          child:

                          MediaQuery.of(context).size.width <= 820?

                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                drawerSide(context),


                                MediaQuery.of(context).size.width <= 820? Container() : Expanded(
                                  child: Board(),
                                ),
                              ],
                            ),
                          )

                          :Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              drawerSide(context),


                              MediaQuery.of(context).size.width <= 820? Container() : Expanded(
                                child: Board(),
                              ),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }


  Widget drawerWidget(BuildContext context){
    return Container(
      // width: MySize.safeWidth * 0.3,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffFDFDFD),
        border: Border(
          right: BorderSide(
            // color: Theme.of(context).primaryColor.withOpacity(0.3),
              color: Color(0xffE2E3E5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MySize.size24, right: MySize.size24, top: MySize.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GetX<AuthController>(
                    builder: (AuthController controller) {
                      final User user = controller.loggedInUser.value;
                      return

                        ListTile(
                            minLeadingWidth: MySize.size15,
                            contentPadding: const EdgeInsets.all(0),
                            //leading: Image.asset('icons/Group 1.png',width: MySize.size30,height: MySize.size30,),

                            title: Text(
                              '${user.firstname} ${user.lastname}',
                              style:
                              TextStyle(fontSize: MySize.size18, fontWeight: FontWeight.w600),
                            ),
                            subtitle:
                            Text(
                              'Workspace',
                              style: TextStyle(
                                  fontSize: MySize.size14, fontWeight: FontWeight.normal),
                            ),
                            trailing: InkWell(
                              onTap: (){
                                scaffoldKey.currentState.closeDrawer();
                              },
                              child: CircleAvatar(
                                radius: MySize.size10,
                                backgroundColor: const Color(0xffE2E3E5),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: MySize.size3,
                                        top: MySize.size2,
                                        bottom: MySize.size2),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: MySize.size10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )

                        );


                    }),
                SizedBox(
                  height: MySize.size8,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: MySize.size8),
            child: Text(
              'ÜBERSICHT',
              style: TextStyle(
                  fontSize: MySize.size10, fontWeight: FontWeight.w600),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                left: MySize.size24, right: MySize.size24, top: MySize.size8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  onTap: (){
                    controller.selectBoard();
                  },
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity:
                  const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Container(
                    width: MySize.size20,
                    height: MySize.size20,
                    decoration: BoxDecoration(
                        color: const Color(0xffE2E3E5),
                        borderRadius:
                        BorderRadius.circular(MySize.size8)),
                    child: Center(
                      child: Image.asset(
                        'icons/Fill 4.png',
                        width: MySize.size9,
                      ),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).boardLabel,
                    style: TextStyle(
                        fontSize: MySize.size16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  onTap: (){
                    controller.selectSettings();
                  },
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity:
                  const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Container(
                    width: MySize.size20,
                    height: MySize.size20,
                    decoration: BoxDecoration(
                        color: const Color(0xffE2E3E5),
                        borderRadius:
                        BorderRadius.circular(MySize.size8)),
                    child: Center(
                      child: Image.asset(
                        'icons/Fill 1.png',
                        width: MySize.size6,
                      ),
                    ),
                  ),

                  title: Text(
                    AppLocalizations.of(context).settingsLabel,
                    style: TextStyle(
                        fontSize: MySize.size16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  visualDensity:
                  const VisualDensity(horizontal: 0, vertical: -4),
                  contentPadding: const EdgeInsets.all(0),
                  leading: Container(
                    width: MySize.size20,
                    height: MySize.size20,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(MySize.size8)),
                    child: Center(
                      child: Image.asset(
                        'icons/Profile.png',
                        width: MySize.size15,
                      ),
                    ),
                  ),
                  title: Text(
                    'Member',
                    style: TextStyle(
                        fontSize: MySize.size16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: MySize.size10,
                ),
              ],
            ),
          ),

          const Divider(
            thickness: 1,
            color: Color(0xffE2E3E5),
          ),
          SizedBox(
            height: MySize.size8,
          ),

          Padding(
            padding: EdgeInsets.only(left: MySize.size8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WORKSPACE',
                  style: TextStyle(
                      fontSize: MySize.size10,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: MySize.size15,
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) =>
                          GetBuilder<CreateProjectController>(
                            init: CreateProjectController(),
                            builder: (_) => AddProjectDialog(),
                          ),
                    );
                  },
                  color: const Color(0xff313133),
                )
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: MySize.size16, right: MySize.size24, top: MySize.size8),
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  String title = '';

                  try {
                    title = controller
                        .activeUserProjects.value[i].name;
                  } catch (e) {
                    title = '';
                  }

                  int projectId = -1;
                  try {
                    projectId = controller
                        .activeUserProjects.value[i].projectId;
                  } catch (e) {
                    projectId = -1;
                  }

                  return Obx(() => Container(
                    decoration: controller.selectedProject
                        .value.projectId !=
                        projectId
                        ? const BoxDecoration()
                        : BoxDecoration(
                        color:
                        Colors.white.withOpacity(0.8),
                        borderRadius:
                        BorderRadius.circular(MySize.size12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.03),
                              spreadRadius: 6,
                              blurRadius: MySize.size10)
                        ]),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      onTap: () {
                        controller
                            .selectProject(projectId);
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
                              color: controller
                                  .selectedProject
                                  .value
                                  .projectId !=
                                  projectId
                                  ? const Color(0xffE2E3E5)
                                  : const Color(0xff3F59FF),
                              borderRadius:
                              BorderRadius.circular(MySize.size8)),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: controller
                                  .selectedProject
                                  .value
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
                itemCount: controller
                    .activeUserProjects.value.length,
              ),
            ),
          ),

          const Divider(
            thickness: 1,
            color: Color(0xffE2E3E5),
          ),
          SizedBox(
            height: MySize.size16,
          ),
          Container(
            child: ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    const AssetImage('icons/Image (1).png'),
                    radius: MySize.size20,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: MySize.size6,
                    ),
                  )
                ],
              ),
              title: Text(
                'Kaenu Gaurava',
                style: TextStyle(
                    fontSize: MySize.size16,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Product Manager',
                style: TextStyle(
                    fontSize: MySize.size10,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          SizedBox(
            height: MySize.size16,
          ),

        ],
      ),
    );
  }

  Widget drawerSide(BuildContext context) {
    Widget widget =  MediaQuery.of(context).size.width <= 820?
        mobileView()
        :DesktopView();

    return widget;
  }

  List<String> actions = [
    'Todo',
    'In-progress',
    'In Review',
    'Completed'
  ];

  var selectedAction = 0.obs;

  List<Widget> actionsWidget ;

  Widget mobileView() {
    return Container(
      padding: EdgeInsets.only(left: MySize.size13),
        width: Get.width,
        // height: MySize.safeHeight*0.96,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [



            Container(
              width: double.infinity,
              child: Row(
                children: [
                  IconButton(onPressed: (){

                    scaffoldKey.currentState.openDrawer();

                  }, icon: const Icon(Icons.menu)),


                  const Spacer(),

                  Container(
                    width: MySize.safeWidth*0.6,
                    height: MySize.size40,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            // style: TextStyle(
                            //     fontSize:
                            //         MySize.size13),
                            decoration:
                            InputDecoration(
                                hintText:
                                'Type anything to search',

                                hintStyle: TextStyle(
                                    fontSize: MySize
                                        .size13,overflow: TextOverflow.ellipsis),
                                prefixIcon:
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                        MySize.size10),
                                    padding:
                                    EdgeInsets.all(
                                        MySize.size10),
                                    child: Image
                                        .asset(
                                      'icons/search.png',
                                      width:
                                      MySize.size15,
                                      height:
                                      MySize.size15,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xffB1B1FF).withOpacity(
                                            0.24)),
                                    borderRadius:
                                    BorderRadius.circular(MySize
                                        .size32)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(
                                        color:
                                        const Color(0xffB1B1FF).withOpacity(0.24)),
                                    borderRadius: BorderRadius.circular(MySize.size32)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xffB1B1FF).withOpacity(0.24)), borderRadius: BorderRadius.circular(MySize.size32))),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: MySize.size42,
                    height: MySize.size42,
                    decoration: const BoxDecoration(
                      color: Color(0xff2E3A59),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.person,color: Colors.white,),),
                  ),



                ],
              ),
            ) ,
            SizedBox(
              height: MySize.size20,
            ),


            GetX<AuthController>(
                builder: (AuthController controller) {
                  final User user = controller.loggedInUser.value;
                  return

                    Text(
                      'Hello ${user.firstname}!',
                      style:
                      GoogleFonts.poppins(fontSize: MySize.size30, fontWeight: FontWeight.bold,color: const Color(0xff2E3A59)),
                    );


                }),

            ShadowText(
              'Have a nice day.',
              style:
              GoogleFonts.poppins(fontSize: MySize.size20,color: const Color(0xff8D94A4)),
            ),

            SizedBox(
              height: MySize.size12,
            ),

            // Container(
            //   width: double.infinity,
            //   height: 40,
            //   // padding: EdgeInsets.only(top: 10,bottom: 10),
            //   child: ListView.builder(itemBuilder: (ctx,i){
            //
            //
            //
            //     return Obx(()=> InkWell(
            //       onTap: (){
            //         print("hi");
            //         selectedAction.value = i;
            //       },
            //       child: Container(
            //         margin: EdgeInsets.only(left: MySize.size10,top: 6,bottom: 6),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(75),
            //             color: Colors.white,
            //             boxShadow: [
            //               BoxShadow(
            //                   color: Colors.black.withOpacity(0.05),
            //                   spreadRadius: 2,
            //                   blurRadius: 4,
            //                   offset: Offset(2,3)
            //               )
            //             ]
            //         ),
            //         child: Chip(
            //
            //           backgroundColor: selectedAction.value == i? Colors.white : Color(0xffE5EAFC),
            //           label: Text(actions[i],style: GoogleFonts.poppins(fontSize: selectedAction.value == i? MySize.size16:MySize.size14,color: Color(0xff242736)),),),
            //       ),
            //     ));
            //   },itemCount: 4,scrollDirection: Axis.horizontal,),
            // ),
            //
            // SizedBox(
            //   height: MySize.size12,
            // ),
            //
            // Container(
            //   width: double.infinity,
            //   height: 5,
            //   decoration: BoxDecoration(
            //       color: Color(0xffE5EAFC),
            //       borderRadius: BorderRadius.circular(8)
            //   ),
            //
            // ),
            // SizedBox(
            //   height: MySize.size8,
            // ),
            Container(
              width: double.infinity,
              height: MySize.size400+MySize.size2,
              child: actionsWidget[0],
            ),
            SizedBox(
              height: MySize.size8,
            ),
            Container(
              width: double.infinity,
              height:MySize.size400+MySize.size2,
              child: actionsWidget[1],
            ),
            SizedBox(
              height: MySize.size8,
            ),
            Container(
              width: double.infinity,
              height: MySize.size400+MySize.size2,
              child: actionsWidget[2],
            ),

            SizedBox(
              height: MySize.size8,
            ),

            Container(
              width: double.infinity,
              height: MySize.size400+MySize.size2,
              child: actionsWidget[3],
            ),

          ],
        ));
  }


  Widget DesktopView() {
    return Obx(
          () => Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [



              Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [


                    Text(
                      controller.selectedProject.value
                          ?.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      // textScaleFactor: 3,
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
                          Expanded(
                            child: TextField(
                              // style: TextStyle(
                              //     fontSize:
                              //         MySize.size13),
                              decoration:
                              InputDecoration(
                                  hintText:
                                  'Type anything to search',
                                  hintStyle: TextStyle(
                                      fontSize: MySize
                                          .size13),
                                  prefixIcon:
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                          MySize.size10),
                                      padding:
                                      EdgeInsets.all(
                                          MySize.size10),
                                      child: Image
                                          .asset(
                                        'icons/search.png',
                                        width:
                                        MySize.size15,
                                        height:
                                        MySize.size15,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xffB1B1FF).withOpacity(
                                              0.24)),
                                      borderRadius:
                                      BorderRadius.circular(MySize
                                          .size32)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(
                                          color:
                                          const Color(0xffB1B1FF).withOpacity(0.24)),
                                      borderRadius: BorderRadius.circular(MySize.size32)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xffB1B1FF).withOpacity(0.24)), borderRadius: BorderRadius.circular(MySize.size32))),
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
                'In Design kanban will contains all the essetial tasks related to \nthe design production in the origins app.',
                style: GoogleFonts.inter(
                    fontSize: MySize.size15,
                    color: const Color(0xff6E7073)
                        .withOpacity(0.64)),
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
          width: MediaQuery.of(context).size.width/5.3,
          // (MediaQuery.of(context).size.width - MySize.size200) / 2.8 -
          //     25,
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
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                  backgroundColor: bgColor,
                  label: Text(
                    columnTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MySize.size10,
                        fontWeight: FontWeight.bold),
                  )),

              PopupMenuButton<int>(
                itemBuilder: (context) {
                  return <PopupMenuEntry<int>>[
                    const PopupMenuItem(child: const Text('0'), value: 0),
                    const PopupMenuItem(child: const Text('1'), value: 1),
                  ];
                },
              ),

              ///todo: The add icon wiget on right side of todo list
              // if (showCreateCardIconButton)
              //   SizedBox(
              //     height: 14,
              //     child: IconButton(
              //       padding: const EdgeInsets.all(0.0),
              //       icon: const Icon(Icons.add),
              //       iconSize: 14,
              //       color: Theme.of(context).primaryColor,
              //       onPressed: () => showDialog<void>(
              //         context: context,
              //         builder: (BuildContext context) =>
              //             GetBuilder<CreateTaskController>(
              //           init: CreateTaskController(),
              //           builder: (_) => AddTaskDialog(),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => Scrollbar(
              key: ValueKey<int>(controller.tasks.length),
              isAlwaysShown: false,
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
  ShadowText(this.data, { this.style }) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          new BackdropFilter(

            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}


/// todo: Bellow is the kanban board for mobile view
///
///

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
          // (MediaQuery.of(context).size.width - MySize.size200) / 2.8 -
          //     25,
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
            children: <Widget>[
              Chip(
                  backgroundColor: bgColor,
                  label: Text(
                    columnTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MySize.size10,
                        fontWeight: FontWeight.bold),
                  )),

              PopupMenuButton<int>(
                itemBuilder: (context) {
                  return <PopupMenuEntry<int>>[
                    const PopupMenuItem(child: Text('0'), value: 0),
                    const PopupMenuItem(child: const Text('1'), value: 1),
                  ];
                },
              ),

              ///todo: The add icon wiget on right side of todo list
              // if (showCreateCardIconButton)
              //   SizedBox(
              //     height: 14,
              //     child: IconButton(
              //       padding: const EdgeInsets.all(0.0),
              //       icon: const Icon(Icons.add),
              //       iconSize: 14,
              //       color: Theme.of(context).primaryColor,
              //       onPressed: () => showDialog<void>(
              //         context: context,
              //         builder: (BuildContext context) =>
              //             GetBuilder<CreateTaskController>(
              //           init: CreateTaskController(),
              //           builder: (_) => AddTaskDialog(),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),


        Container(
          width: double.infinity,
          height: MySize.size320+MySize.size28,
          child: Obx(
                () => Scrollbar(
              key: ValueKey<int>(controller.tasks.length),
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.symmetric(
                //   vertical: MySize.size8,
                // ),
                controller: _scrollController,
                children: controller.tasks
                    .where((Task task) => task.status == status)
                    .map((Task task) => DraggableTaskCardRow(task: task))
                    .toList(),
              ),
            ),
          ),
        ),

        // Container(
        //   height: 400,
        //   width: double.infinity,
        //   child: Obx(
        //         () => Scrollbar(
        //       key: ValueKey<int>(controller.tasks.length),
        //       isAlwaysShown: false,
        //       controller: _scrollController,
        //       child: ListView(
        //         scrollDirection: Axis.horizontal,
        //         padding: EdgeInsets.symmetric(
        //           vertical: MySize.size8,
        //         ),
        //         controller: _scrollController,
        //         children: controller.tasks
        //             .where((Task task) => task.status == status)
        //             .map((Task task) => DraggableTaskCardRow(task: task))
        //             .toList(),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
