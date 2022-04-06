import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controller/create_project_controller.dart';
import '../../service/SizeConfig.dart';
import 'add_project_dialog.dart';

class BoardNavigation extends GetView<BoardController> {
  BoardNavigation({Key key, this.child}) : super(key: key);

  final Widget child;

  BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    final int tabIndex = controller.tabIndex;

    MySize().init(context);

    return Row(
      children: <Widget>[
        // ignore: prefer_if_elements_to_conditional_expressions
        MediaQuery.of(context).size.width <= 820
            ? Container()
            : Container(
                width: Get.width * 0.2,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border(
                    right: BorderSide(
                        color: Get.isDarkMode
                            ? Colors.brown
                            : const Color(0xffE2E3E5)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: MySize.size24,
                          right: MySize.size24,
                          top: MySize.size24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            Get.isDarkMode
                                ? 'images/bee_busy_logo_dark_mode.png'
                                : 'images/bee_busy_logo_light_mode.png',
                            width: 155,
                          ),
                          const SizedBox(
                            height: kSpacing,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MySize.size8),
                      child: Text(
                        'ÜBERSICHT',
                        style: TextStyle(
                            fontSize: MySize.size10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MySize.size20,
                          right: MySize.size20,
                          top: MySize.size8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: tabIndex != 0
                                    ? Colors.transparent
                                    : Colors.amber,
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius)),
                            child: ListTile(
                              onTap: () {
                                Get.find<BoardController>().changeTabIndex(0);
                              },
                              contentPadding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              leading: Container(
                                width: MySize.size20,
                                height: MySize.size20,
                                child: Center(
                                  child: Icon(Icons.dashboard,
                                      size: MySize.size20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                              title: BrownText(
                                AppLocalizations.of(context).boardLabel,
                                isBold: true,
                                fontSize: MySize.size16,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: tabIndex != 1
                                    ? Colors.transparent
                                    : Colors.amber,
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius)),
                            child: ListTile(
                              onTap: () {
                                Get.find<BoardController>().changeTabIndex(1);
                              },
                              contentPadding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              leading: Container(
                                width: MySize.size20,
                                height: MySize.size20,
                                child: Center(
                                  child: Icon(
                                    Icons.settings,
                                    size: MySize.size20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              title: BrownText(
                                AppLocalizations.of(context).settingsLabel,
                                isBold: true,
                                fontSize: MySize.size16,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: tabIndex != 2
                                    ? Colors.transparent
                                    : Colors.amber,
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius)),
                            child: ListTile(
                              onTap: () {
                                Get.find<BoardController>().changeTabIndex(2);
                              },
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              contentPadding: const EdgeInsets.all(0),
                              leading: Container(
                                width: MySize.size20,
                                height: MySize.size20,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size8)),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: MySize.size20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              title: BrownText(
                                AppLocalizations.of(context).profileLabel,
                                isBold: true,
                                fontSize: MySize.size16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MySize.size10,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Get.isDarkMode
                          ? Colors.brown
                          : const Color(0xffE2E3E5),
                    ),
                    SizedBox(
                      height: MySize.size8,
                    ),
                    //Empty widget to align the button 
                    Expanded(child: Container()),

                    /*  Padding(
                          padding: EdgeInsets.only(left: MySize.size8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
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
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ],
                          ),
                        ), */

                    /* Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: MySize.size8),
                            child: ListView.builder(
                              itemBuilder: (BuildContext ctx, int i) {
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

                                return Obx(() => Card(
                                   elevation: 1,
                                    shadowColor: Colors.black,
                                  child: ListTile(
                                     trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      Get.find<BoardController>()
                                          .changeTabIndex(1);
                                    },
                                    icon: Icon(
                                      Icons.settings,
                                      size: MySize.size16,
                                       color: Theme.of(context).colorScheme.primary,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            MyAlertDialog(
                                          title: AppLocalizations.of(context)
                                              .deleteProjectButton,
                                          content: AppLocalizations.of(context)
                                              .deleteProjectQuestion,
                                          onConfirm: controller.deleteProject,
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: MySize.size18,
                                      color: Theme.of(context).colorScheme.primary,
                                    )),
                              ],
                            ),
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
                        ), */
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: MySize.size16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              color: kSecondaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TextButton.icon(
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GetBuilder<
                                          CreateProjectController>(
                                        init: CreateProjectController(),
                                        builder: (_) => AddProjectDialog(),
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.add_task_outlined,
                                size: 16,
                                color: Get.isDarkMode
                                    ? const Color(0XFF1A1103)
                                    : const Color(0xFF593D0C),
                              ),
                              label: Text(
                                AppLocalizations.of(context).createProjectTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? const Color(0XFF1A1103)
                                        : const Color(0xFF593D0C)),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MySize.size16,
                    ),
                  ],
                ),
              ),
        if (child != null)
          Expanded(
              child: Container(
            child: child,
          )),
      ],
    );
  }
}
