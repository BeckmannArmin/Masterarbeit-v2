import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import 'add_project_dialogv2.dart';

class DrawerSide extends GetView<BoardController> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
                  left: MySize.size24,
                  right: MySize.size10,
                  top: MySize.size10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Get.isDarkMode
                              ? 'images/bee_busy_logo_dark_mode.png'
                              : 'images/bee_busy_logo_light_mode.png',
                          width: 125,
                        ),
                        InkWell(
                            onTap: () {
                              Scaffold.of(context).closeDrawer();
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
                                )))
                      ],
                    ),
                  ),
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
                    left: MySize.size16,
                    right: MySize.size24,
                    top: MySize.size8),
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
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                      showModalBottomSheet<void>(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(kBorderRadius),
                                topLeft: Radius.circular(kBorderRadius)),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          context: context,
                          builder: (BuildContext context) {
                            return GetBuilder<CreateProjectController>(
                              init: CreateProjectController(),
                              builder: (_) => AddModalProjectDialog(context),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.add_task_outlined,
                      size: 24.0,
                    ),
                    label: Text(
                      AppLocalizations.of(context).createProjectTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            SizedBox(
              height: MySize.size16,
            ),
          ],
        ),
      ),
    );
  }
}
