import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:beebusy_app/ui/widgets/header_profile.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/auth_controller.dart';
import '../../controller/create_project_controller.dart';
import '../../model/user.dart';
import '../../service/SizeConfig.dart';
import 'add_project_dialog.dart';

class BoardNavigation extends GetView<BoardController> {
  BoardNavigation({Key key, this.child}) : super(key: key);

  final Widget child;

  BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {


    MySize().init(context);

    return Row(
      children: <Widget>[
        // ignore: prefer_if_elements_to_conditional_expressions
        MediaQuery.of(context).size.width <= 820
                ? Container()
                : Container(
                    width: Get.width * 0.2,
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
                                return HeaderImage(
                                  title: '${user.firstname} ${user.lastname}',
                                  subtitle: 'Workspace',
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
                                  'Logout',
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
                                  title = boardController
                                      .activeUserProjects.value[i].name;
                                } catch (e) {
                                  title = '';
                                }

                                int projectId = -1;
                                try {
                                  projectId = boardController
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
                                          boardController
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
                              itemCount: boardController
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
                  )
            ,
        if (child != null)
          Expanded(
              child: Container(
            child: child,
            color: const Color(0xffFDFDFD),
          )),
      ],
    );
  }
}
